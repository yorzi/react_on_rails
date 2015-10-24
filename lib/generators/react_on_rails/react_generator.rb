require "rails/generators"
require File.expand_path("../generator_helper", __FILE__)
include GeneratorHelper

module ReactOnRails
  module Generators
    class ReactGenerator < Rails::Generators::Base
      hide!
      source_root File.expand_path("../templates", __FILE__)

      # --with-redux
      class_option :with_redux,
                   type: :boolean,
                   default: false,
                   desc: "Include Redux package"
      # --with-hello-world-example
      class_option :with_hello_world_example,
                   type: :boolean,
                   default: false,
                   desc: "Include a simple Hello World Example. Note that this example's implementation varies " \
                         "depending on the other options chosen."
      # --with-server-rendering
      class_option :with_server_rendering,
                   type: :boolean,
                   default: false,
                   description: "Enable server-rendering"

      def symlink_client_assets_to_app_assets
        empty_directory("client/app/assets")
        empty_directory_with_keep_file("app/assets/fonts") unless dest_dir_exists?("app/assets/fonts")
        empty_directory_with_keep_file("app/assets/images") unless dest_dir_exists?("app/assets/images")
        symlink_dest_file_to_dest_file("app/assets/fonts", "client/app/assets/fonts")
        symlink_dest_file_to_dest_file("app/assets/images", "client/app/assets/images")
      end

      def update_git_ignore
        data = "# React on Rails\n"
        data << "npm-debug.log\n"
        data << "node_modules\n"
        data << "\n"
        data << "# Generated js bundles\n"
        data << "/app/assets/javascripts/generated/*\n"

        if dest_file_exists?(".gitignore")
          append_to_file(".gitignore", data)
        else
          puts_setup_file_error(".gitignore", data)
        end
      end

      def update_application_js
        data = "\n"
        # TODO: do we need this in here if we are not generating bootstrap?
        # Do we need to sign this as coming from the react_on_rails gem as
        # there may be other boilerplate comments in here?
        data << "// It is important that generated/vendor-bundle must be before "
        data << "bootstrap since it is exposing jQuery and jQuery-ujs\n"
        data << "//= require generated/vendor-bundle\n"
        data << "//= require generated/app-bundle\n"
        data << "//= require react_on_rails\n"
        data << "\n"

        application_js_path = "app/assets/javascripts/application.js"
        application_js = dest_file_exists?(application_js_path) || dest_file_exists?(application_js_path + ".coffee")
        if application_js
          prepend_to_file(application_js, data)
        else
          puts_setup_file_error("#{application_js} or #{application_js}.coffee", data)
        end
      end

      def create_react_directories
        dirs = %w(actions components constants middlewares startup utils)
        dirs.each { |name| empty_directory_with_keep_file "client/app/#{name}" }
      end

      def copy_base_files
        template "react_on_rails.rb", "config/initializers/react_on_rails.rb"
        copy_file "lib/tasks/assets.rake", "lib/tasks/assets.rake"
        copy_file "client/README.md", "client/README.md"
        copy_file "client/server.js", "client/server.js"
        copy_file "client/.babelrc", "client/.babelrc"
        copy_file "client/webpack.client.base.config.js", "client/webpack.client.base.config.js"
        copy_file "client/webpack.client.hot.config.js", "client/webpack.client.hot.config.js"
        copy_file "client/webpack.client.rails.config.js", "client/webpack.client.rails.config.js"
        copy_file "README"
      end

      def copy_appropriate_package_json
        if options.with_redux?
          copy_file "client/redux_package.json", "client/package.json"
        else
          copy_file "client/package.json", "client/package.json"
        end
      end

      def copy_appropriate_globals
        if options.with_hello_world_example?
          copy_file "hello_world_base/client/app/startup/clientGlobals.jsx", "client/app/startup/clientGlobals.jsx"
        else
          copy_file "client/app/startup/clientGlobals.jsx", "client/app/startup/clientGlobals.jsx"
        end
        return unless options.with_server_rendering?

        if options.with_hello_world_example?
          copy_file "hello_world_server_render/client/app/startup/serverGlobals.jsx",
                    "client/app/startup/serverGlobals.jsx"
        else
          copy_file "client/app/startup/serverGlobals.jsx", "client/app/startup/serverGlobals.jsx"
        end
      end

      def copy_appropriate_index_jade
        if options.with_hello_world_example?
          copy_file "hello_world_base/client/index.jade", "client/index.jade"
        else
          copy_file "client/index.jade", "client/index.jade"
        end
      end

      def copy_appropriate_procfile
        dev_procfile = options.with_server_rendering? ? "Procfile.dev.server" : "Procfile.dev.client"
        copy_file dev_procfile, "Procfile.dev"
      end

      def install_server_rendering_files_if_enabled
        return unless options.with_server_rendering?
        copy_file "client/webpack.server.rails.config.js", "client/webpack.server.rails.config.js"
      end
    end
  end
end
