# Install Generator: gem's only public generator
#
# Usage:
#   rails generate react_on_rails:install [options]
#
# Options:
#   [--with-redux], [--no-with-redux]
#     Indicates when to generate with redux
#   [--with-hello-world-example], [--no-with-hello-world-example]
#     Indicates when to generate with hello world example
#   [--with-server-rendering], [--no-with-server-rendering]
#     Indicates whether ability for server-side rendering of webpack output should be enabled
#
require "rails/generators"

module ReactOnRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      # --with-redux
      class_option :with_redux,
                   type: :boolean,
                   default: false,
                   desc: "Include Redux package"
      # --with-hello-world-example
      class_option :with_hello_world_example,
                   type: :boolean,
                   default: false,
                   desc: "Include a simple Hello World Example. Note that this example's implementation varies "\
                         "depending on the other options chosen."
      # --with-server-rendering
      class_option :with_server_rendering,
                   type: :boolean,
                   default: false,
                   desc: "Adds configuration files allowing for server-side rendering of webpack's JavaScript output"

      def run_generators
        return unless installation_prerequisites_met?
        warn_if_nvm_is_not_installed
        invoke "react_on_rails:react"
        invoke "react_on_rails:linters"
        invoke "react_on_rails:hello_world_example" if options.with_hello_world_example?
      end

      private

      # NOTE: other requirements for existing files such as .gitignore or application.js(.coffee) are not checked
      # by this method, but instead produce warning messages and allow the build to continue
      def installation_prerequisites_met?
        return true unless missing_node? || missing_npm?
      end

      # TODO: I'm pretty sure NPM is packaged with Node so this may be redundant (RW)
      def missing_npm?
        return false unless `which npm`.blank?
        error = "** npm is required. Please install it before continuing."
        error << "https://www.npmjs.com/"
        puts error
      end

      def missing_node?
        return false unless `which node`.blank?
        error = "** nodejs is required. Please install it before continuing."
        error << "https://nodejs.org/en/"
        puts error
      end

      def warn_if_nvm_is_not_installed
        puts "** nvm is advised. Please consider installing it. https://github.com/creationix/nvm" if `which nvm`.blank?
      end
    end
  end
end
