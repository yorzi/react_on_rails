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
        copy_file "client/.eslintrc", "client/.eslintrc"
        copy_file "client/.eslintignore", "client/.eslintignore"
        copy_file "client/.jscsrc", "client/.jscsrc"
      end

      def copy_linting_and_audting_tasks
        copy_file "lib/tasks/brakeman.rake", "lib/tasks/brakeman.rake"
        copy_file "lib/tasks/ci.rake", "lib/tasks/ci.rake"
        copy_file "lib/tasks/linters.rake", "lib/tasks/linters.rake"
      end
    end
  end
end
