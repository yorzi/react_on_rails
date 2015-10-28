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
    dirs = %w(components startup utils)
    dirs.each { |dirname| assert_directory_with_keep_file "client/app/#{dirname}" }
  end

  it "copies react files" do
    %w(config/initializers/react_on_rails.rb
       lib/tasks/assets.rake
       client/package.json
       client/package.json
       client/server.js
       client/.babelrc
       client/webpack.client.base.config.js
       client/webpack.client.hot.config.js
       client/webpack.client.rails.config.js
       client/app/startup/clientGlobals.jsx
       client/index.jade
       REACT_ON_RAILS.md
       client/npm-shrinkwrap.json
       client/app/utils/ReactCompat.jsx).each { |file| assert_file(file) }
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
