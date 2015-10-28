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
    assert_file("REACT_ON_RAILS.md") do |contents|
      assert_match(%r{-"Hello World" example: `localhost:3000/hello_world`
-"Hello World" example via Webpack Development Server with Hot Module Reload: `localhost:4000`}, contents)
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
