require "rails/generators"

module ReactOnRails
  module Generators
    class HelloWorldExampleGenerator < Rails::Generators::Base
      hide!
      source_root File.expand_path("../templates", __FILE__)

      # --redux
      class_option :redux,
                   type: :boolean,
                   default: false,
                   desc: "Setup Redux files",
                   aliases: "-d"
      # --server-rendering
      class_option :server_rendering,
                   type: :boolean,
                   default: false,
                   desc: "Configure for server-side rendering of webpack JavaScript",
                   aliases: "-S"

      def insert_hello_world_route
        route("get 'hello_world', to: 'hello_world#index'")
      end

      def copy_hello_world_files
        copy_file("hello_world/app/controllers/hello_world_controller.rb", "app/controllers/hello_world_controller.rb")
        copy_file("hello_world/client/app/components/HelloWorld.jsx", "client/app/components/HelloWorld.jsx")
        copy_file("hello_world/client/app/startup/HelloWorldApp.jsx", "client/app/startup/HelloWorldApp.jsx")
        template("hello_world/app/views/hello_world/index.html.erb.tt", "app/views/hello_world/index.html.erb")
      end
    end
  end
end
