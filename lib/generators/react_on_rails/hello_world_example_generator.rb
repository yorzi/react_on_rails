require "rails/generators"

module ReactOnRails
  module Generators
    class HelloWorldExampleGenerator < Rails::Generators::Base
      hide!
      source_root File.expand_path("../templates", __FILE__)

      # --with-redux
      class_option :with_redux,
                   type: :boolean,
                   default: false,
                   description: "Include Redux package"
      # --with-server-rendering
      class_option :with_server_rendering,
                   type: :boolean,
                   default: false,
                   description: "Enable server-rendering"

      def insert_hello_world_route
        route "get 'hello_world', to: 'pages#index'"
      end

      def copy_base_files
        copy_file "hello_world_base/app/controllers/pages_controller.rb", "app/controllers/pages_controller.rb"
        copy_file "hello_world_base/client/app/components/HelloWorld.jsx", "client/app/components/HelloWorld.jsx"
        copy_file "hello_world_base/client/app/startup/HelloWorldApp.jsx", "client/app/startup/HelloWorldApp.jsx"
      end

      def copy_client_rendering_only_files
        return if options.with_server_rendering?
        copy_file "hello_world_client_render/app/views/pages/index.html.erb", "app/views/pages/index.html.erb"
      end

      def copy_server_rendering_only_files
        return unless options.with_server_rendering?
        empty_directory("app/views/pages")
        copy_file "hello_world_server_render/app/views/pages/index.html.erb", "app/views/pages/index.html.erb"
      end

      def open_hello_world_readme
        copy_file "hello_world_base/README_HELLO_WORLD.md", "README_HELLO_WORLD.md"
      end
    end
  end
end
