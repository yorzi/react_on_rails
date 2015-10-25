require "rails/generators"

module ReactOnRails
  module Generators
    class LintersGenerator < Rails::Generators::Base
      hide!
      source_root File.expand_path("../templates", __FILE__)

      def add_linter_gems
        gem_group :development do
          gem "rubocop"
          gem "scss_lint"
          gem "ruby-lint"
        end
      end

      def copy_linter_config_files
        %w(client/.eslintrc
           client/.eslintignore
           client/.jscsrc).each { |file| copy_file(file) }
      end

      def copy_linting_and_audting_tasks
        %w(lib/tasks/brakeman.rake
           lib/tasks/ci.rake
           lib/tasks/linters.rake).each { |file| copy_file(file) }
      end
    end
  end
end
