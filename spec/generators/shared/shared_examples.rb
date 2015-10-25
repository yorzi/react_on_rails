shared_examples ":react:base" do
  it "symlinks client assets to app assets" do
    assert_directory "app/assets/fonts"
    assert_directory "app/assets/images"
    expect_to_be_symlink(link: "client/app/assets/fonts", target: "app/assets/fonts")
    expect_to_be_symlink(link: "client/app/assets/images", target: "app/assets/images")
  end

  it "updates the .gitignore file" do
    match = <<-MATCH.strip_heredoc
      some existing text
      # React on Rails
      npm-debug.log
      node_modules

      # Generated js bundles
      /app/assets/javascripts/generated/*
    MATCH
    assert_file ".gitignore", match
  end

  it "updates application.js" do
    match = <<-MATCH.strip_heredoc

      // It is important that generated/vendor-bundle must be before bootstrap
      // since it is exposing jQuery and jQuery-ujs
      //= require generated/vendor-bundle
      //= require generated/app-bundle
      //= require react_on_rails

      some existing text
    MATCH
    assert_file "app/assets/javascripts/application.js", match
  end

  it "creates react directories" do
    dirs = %w(actions components constants middlewares startup utils)
    dirs.each { |dirname| assert_directory_with_keep_file "client/app/#{dirname}" }
  end

  it "copies react files" do
    assert_file "config/initializers/react_on_rails.rb"
    assert_file "lib/tasks/assets.rake"
    assert_file "client/package.json"
    assert_file "client/package.json"
    assert_file "client/server.js"
    assert_file "client/.babelrc"
    assert_file "client/webpack.client.base.config.js"
    assert_file "client/webpack.client.hot.config.js"
    assert_file "client/webpack.client.rails.config.js"
    assert_file "client/app/startup/clientGlobals.jsx"
    assert_file "client/index.jade"
    assert_file "README.md"
  end
end

shared_examples ":linters" do
  it "adds linter gems" do
    match = <<-MATCH.strip_heredoc

      group :development do
        gem 'rubocop'
        gem 'scss_lint'
        gem 'ruby-lint'
      end
    MATCH

    assert_file("Gemfile", match)
  end

  it "copies linter config files" do
    assert_file "client/.eslintrc"
    assert_file "client/.eslintignore"
    assert_file "client/.jscsrc"
  end

  it "copies linting and auditing tasks" do
    assert_file "lib/tasks/brakeman.rake"
    assert_file "lib/tasks/ci.rake"
    assert_file "lib/tasks/linters.rake"
  end
end

shared_examples ":react" do
  include_examples ":react:base"

  it "copies client-side version of Procfile.dev" do
    assert_client_render_procfile
  end

  it "does not copy react server-rendering-specific files" do
    assert_no_file "client/webpack.server.rails.config.js"
    assert_no_file "client/app/startup/serverGlobals.jsx"
  end
end

shared_examples ":react:server_rendering" do
  include_examples ":react:base"

  it "copies server-rendering-specific react files" do
    assert_file "client/webpack.server.rails.config.js"
    assert_file "client/app/startup/serverGlobals.jsx"
  end

  it "copies react server-rendering-specific files" do
    assert_server_render_procfile
  end
end

shared_examples ":redux" do
  it "copies redux version of package.json" do
    assert_file "client/package.json" do |contents|
      assert_match(/redux/, contents)
    end
  end
end

shared_examples ":hello_world_example:base" do
  it "copies hello_world version of index.jade" do
    assert_file "client/index.jade" do |contents|
      refute_match(/ReactDOM.render\(ComponentName, document.getElementById\('app'\)\);/, contents)
      assert_match(/React.render\(HelloWorldApp, document.getElementById\('app'\)\)/, contents)
    end
  end

  it "copies pages_controller.rb" do
    assert_file "app/controllers/hello_world_controller.rb"
  end

  it "adds a route for get 'hello_world' to 'hello_world#index'" do
    match = <<-MATCH.strip_heredoc
      Rails.application.routes.draw do
        get 'hello_world', to: 'hello_world#index'
      end
    MATCH
    assert_file "config/routes.rb", match
  end

  it "has hello_world information in README.md" do
    assert_file("README.md") do |contents|
      assert_match(%r{-"Hello World" example: `localhost:3000/hello_world`
-Webpack Development Server with Hot Module Reload: `localhost:4000`}, contents)
    end
  end
end

shared_examples ":hello_world_example" do
  include_examples ":hello_world_example:base"

  it "copies client-rendering version of Procfile.dev" do
    assert_client_render_procfile
  end

  it "copies hello_world_client_render version of files" do
    assert_file "app/views/hello_world/index.html.erb" do |contents|
      refute_match(/Server Rendering/, contents)
    end
  end
end

shared_examples ":hello_world_example:server_rendering" do
  include_examples ":hello_world_example:base"

  it "copies client-rendering version of Procfile.dev" do
    assert_server_render_procfile
  end

  it "copies webpack.server.rails.config.js" do
    assert_file "client/webpack.server.rails.config.js"
  end

  it "copies server-side rendering version of app files" do
    assert_file "app/views/hello_world/index.html.erb" do |contents|
      assert_match(/Server Rendering/, contents)
    end
  end
end

def assert_server_render_procfile
  assert_file "Procfile.dev" do |contents|
    assert_match(/\n\s*server:/, contents)
  end
end

def assert_client_render_procfile
  assert_file "Procfile.dev" do |contents|
    refute_match(/\n\s*server:/, contents)
  end
end
