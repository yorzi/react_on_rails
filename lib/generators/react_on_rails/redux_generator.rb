require "rails/generators"
require File.expand_path("../generator_helper", __FILE__)
include GeneratorHelper

module ReactOnRails
  module Generators
    class ReduxGenerator < Rails::Generators::Base
      hide!
      source_root(File.expand_path("../templates", __FILE__))

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

      def create_react_directories
        dirs = %w(actions constants middlewares reducers utils)
        dirs.each { |name| empty_directory("client/app/#{name}") }
      end

      def copy_base_redux_files
        template("redux/client/app/reducers/reducersIndex.jsx.tt", "client/app/reducers/reducersIndex.jsx")
        template("redux/client/app/startup/ClientReduxApp.jsx.tt", "client/app/startup/ClientReduxApp.jsx")
      end

      def copy_hello_world_example_files_if_approprirate
        return if options.skip_hello_world_example?
        copy_file("redux_and_hello_world/client/app/constants/HelloWorldConstants.jsx",
                  "client/app/constants/HelloWorldConstants.jsx")
        copy_file("redux_and_hello_world/client/app/actions/HelloWorldActions.jsx",
                  "client/app/actions/HelloWorldActions.jsx")
        copy_file("redux_and_hello_world/client/app/reducers/HelloWorldReducer.jsx",
                  "client/app/reducers/HelloWorldReducer.jsx")
        copy_file("redux_and_hello_world/client/app/components/HelloWorldContainer.jsx",
                  "client/app/components/HelloWorldContainer.jsx")
        copy_file("redux_and_hello_world/client/app/components/HelloWorldRedux.jsx",
                  "client/app/components/HelloWorldRedux.jsx")
      end

      def copy_server_rendering_redux_files_if_appropriate
        return unless options.server_rendering?
        template("redux/client/app/startup/ServerReduxApp.jsx.tt", "client/app/startup/ServerReduxApp.jsx")
      end
    end
  end
end
