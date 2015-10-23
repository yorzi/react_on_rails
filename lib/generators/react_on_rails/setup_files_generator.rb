require "rails/generators"
require File.expand_path("../generator_helper", __FILE__)
include GeneratorHelper

module ReactOnRails
  module Generators
    class SetupFilesGenerator < Rails::Generators::Base
      hide!
      source_root File.expand_path("../templates", __FILE__)

      def create_assets
        empty_directory_with_keep_file "client/assets/stylesheets"

        # TODO: verify this is desired behavior (RW)
        create_link "client/assets/fonts", "../../app/assets/fonts" if dest_dir_exists?("app/assets/fonts")
        create_link "client/assets/images", "../../app/assets/images" if dest_dir_exists?("app/assets/images")
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
        application_js = "app/assets/javascripts/application.js"
        data = "\n"
        data << "// It is important that generated/vendor-bundle must be before"
        data << "bootstrap since it is exposing jQuery and jQuery-ujs\n"
        data << "//= require generated/vendor-bundle\n"
        data << "//= require generated/app-bundle\n"
        data << "//= require react_on_rails\n"
        data << "\n"

        if dest_file_exists?(application_js)
          prepend_to_file(application_js, data)
        elsif dest_file_exists?(application_js + ".coffee")
          prepend_to_file(application_js, data)
        else
          puts_setup_file_error("#{application_js} or #{application_js}.coffee", data)
        end
      end

      def copy_config
        template "react_on_rails.rb", "config/initializers/react_on_rails.rb"
      end

      def add_gems
        gem_group :development do
          gem "rubocop"
          gem "scss_lint"
          gem "ruby-lint"
        end
      end
    end
  end
end
