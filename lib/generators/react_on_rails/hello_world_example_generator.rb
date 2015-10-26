require "rails/generators"

module ReactOnRails
  module Generators
    class HelloWorldExampleGenerator < Rails::Generators::Base
      hide!
      source_root File.expand_path("../templates", __FILE__)

      # --with-redux
      class_option :redux,
                   type: :boolean,
                   default: false,
                   description: "Include Redux package"
      # --with-server-rendering
      class_option :server_rendering,
                   type: :boolean,
                   default: false,
                   description: "Enable server-rendering"

      def insert_hello_world_route
        route("get 'hello_world', to: 'hello_world#index'")
      end

      def copy_base_files
        copy_file("hello_world_base/app/controllers/hello_world_controller.rb",
                  "app/controllers/hello_world_controller.rb")
        copy_file("hello_world_base/client/app/components/HelloWorld.jsx", "client/app/components/HelloWorld.jsx")
        copy_file("hello_world_base/client/app/startup/HelloWorldApp.jsx", "client/app/startup/HelloWorldApp.jsx")
      end

      def copy_client_rendering_only_files
        return if options.server_rendering?
        copy_file("hello_world_client_render/app/views/hello_world/index.html.erb",
                  "app/views/hello_world/index.html.erb")
      end

      def copy_server_rendering_only_files
        return unless options.server_rendering?
        copy_file_and_missing_parent_directories("hello_world_server_render/app/views/hello_world/index.html.erb",
                                                 "app/views/hello_world/index.html.erb")
      end
    end
  end
end
