# require "spec_helper"
require "generator_spec" # let's us use Rails's generator testing helpers but iwth RSpec syntax
require "pathname"
require File.expand_path("../../../lib/generators/react_on_rails/install_generator", __FILE__)
include ReactOnRails::Generators

describe InstallGenerator, type: :generator do
  destination File.expand_path("../../dummy-for-generators/", __FILE__)

  shared_examples "basic needed files" do
    it "generates the basic needed files" do
      assert_directory "client"
      assert_file "client/package.json"
    end

    it "adds to .gitignore file" do
      match = "some existing text\n"
      match << "# React on Rails\n"
      match << "npm-debug.log\n"
      match << "node_modules\n"
      match << "\n"
      match << "# Generated js bundles\n"
      match << "/app/assets/javascripts/generated/*\n"
      assert_file ".gitignore", match
    end

    it "adds to application.js" do
      match = "\n"
      match << "// It is important that generated/vendor-bundle must be before "
      match << "bootstrap since it is exposing jQuery and jQuery-ujs\n"
      match << "//= require generated/vendor-bundle\n"
      match << "//= require generated/app-bundle\n"
      match << "//= require react_on_rails\n"
      match << "\n"
      match << "some existing text\n"
      assert_file "app/assets/javascripts/application.js", match
    end
  end

  context "with no arguments" do
    before(:all) do
      prepare_destination # this completely wipes the `destination` directory
      simulate_existing_file(".gitignore")
      simulate_existing_file("Gemfile")
      simulate_existing_file("app/assets/javascripts/application.js")
      run_generator
    end

    include_examples "basic needed files"
  end

  # Simulate having an existing file for cases where the generator needs to modify, not create, a file
  def simulate_existing_file(file, data = "some existing text\n")
    path = Pathname.new(File.join(destination_root, file))
    mkdir_p(path.dirname)
    File.open(path, "w+") do |f|
      f.puts data
    end
  end
end
