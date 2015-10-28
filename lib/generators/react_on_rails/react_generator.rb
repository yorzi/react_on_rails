require "rails/generators"
require File.expand_path("../generator_helper", __FILE__)
include GeneratorHelper

module ReactOnRails
  module Generators
    class ReactGenerator < Rails::Generators::Base
      hide!
      source_root(File.expand_path("../templates", __FILE__))

      # --redux
      class_option :redux,
                   type: :boolean,
                   default: false,
                   desc: "Setup Redux files",
                   aliases: "-d"
      # --skip-hello-world-example
      class_option :skip_hello_world_example,
                   type: :boolean,
                   aliases: "-H",
                   default: false,
                   desc: "Don't include the Hello World example"
      # --server-rendering
      class_option :server_rendering,
                   type: :boolean,
                   default: false,
                   desc: "Configure for server-side rendering of webpack JavaScript",
                   aliases: "-S"

      def symlink_client_assets_to_app_assets
        empty_directory("client/app/assets")
        empty_directory_with_keep_file("app/assets/fonts") unless dest_dir_exists?("app/assets/fonts")
        empty_directory_with_keep_file("app/assets/images") unless dest_dir_exists?("app/assets/images")
        symlink_dest_file_to_dest_file("app/assets/fonts", "client/app/assets/fonts")
        symlink_dest_file_to_dest_file("app/assets/images", "client/app/assets/images")
      end

      def update_git_ignore
        data = <<-DATA.strip_heredoc
          # React on Rails
          npm-debug.log
          node_modules

          # Generated js bundles
          /app/assets/javascripts/generated/*
        DATA

        dest_file_exists?(".gitignore") ? append_to_file(".gitignore", data) : puts_setup_file_error(".gitignore", data)
      end

      def update_application_js
        # TODO: do we need this in here if we are not generating bootstrap?
        # Do we need to sign this as coming from the react_on_rails gem as
        # there may be other boilerplate comments in here?
        data = <<-DATA.strip_heredoc

          // It is important that generated/vendor-bundle must be before bootstrap
          // since it is exposing jQuery and jQuery-ujs
          //= require generated/vendor-bundle
          //= require generated/app-bundle
          //= require react_on_rails

        DATA

        application_js_path = "app/assets/javascripts/application.js"
        application_js = dest_file_exists?(application_js_path) || dest_file_exists?(application_js_path + ".coffee")
        if application_js
          prepend_to_file(application_js, data)
        else
          puts_setup_file_error("#{application_js} or #{application_js}.coffee", data)
        end
      end

      def create_react_directories
        dirs = %w(components startup utils)
        dirs.each { |name| empty_directory_with_keep_file("client/app/#{name}") }
      end

      def copy_base_files
        copy_file_and_missing_parent_directories("config/initializers/react_on_rails.rb")
        %w(lib/tasks/assets.rake
           client/server.js
           client/.babelrc
           client/webpack.client.base.config.js
           client/webpack.client.hot.config.js
           client/webpack.client.rails.config.js
           client/npm-shrinkwrap.json
           client/app/utils/ReactCompat.jsx).each { |file| copy_file(file) }
      end

      def template_base_files
        %w(REACT_ON_RAILS.md.tt
           client/app/startup/clientGlobals.jsx.tt
           client/index.jade.tt
           Procfile.dev.tt).each { |file| template(file) }
      end

      def copy_appropriate_package_json
        source = options.redux? ? "client/redux_package.json" : "client/package.json"
        copy_file(source, "client/package.json")
      end

      def install_server_rendering_files_if_enabled
        return unless options.server_rendering?
        copy_file("client/webpack.server.rails.config.js")
        template("client/app/startup/serverGlobals.jsx.tt")
      end
    end
  end
end
