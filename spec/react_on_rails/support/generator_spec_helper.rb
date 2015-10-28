require "react_on_rails/simplecov_helper"
require "generator_spec" # let's us use Rails's generator testing helpers but with RSpec syntax
Dir[File.expand_path("../../support/shared_examples", __FILE__) + "/*.rb"].each { |file| require file }
require File.expand_path("../../../../lib/generators/react_on_rails/install_generator", __FILE__)
include ReactOnRails::Generators

# Expects an array of strings, such as "--redux"
def run_generator_test_with_args(args)
  prepare_destination # this completely wipes the `destination` directory
  simulate_existing_file(".gitignore")
  simulate_existing_file("app/assets/javascripts/application.js")
  simulate_existing_file("Gemfile", nil)
  simulate_existing_file("config/routes.rb", "Rails.application.routes.draw do\nend\n")
  run_generator(args)
end

def assert_server_render_procfile
  assert_file "Procfile.dev" do |contents|
    assert_match(/\n\s*server:/, contents)
  end
end

def assert_client_render_procfile
  assert_file "Procfile.dev" do |contents|
    refute_match(/\n\s*server:/, contents)
  end
end

# Simulate having an existing file for cases where the generator needs to modify, not create, a file
def simulate_existing_file(file, data = "some existing text\n")
  path = Pathname.new(File.join(destination_root, file))
  mkdir_p(path.dirname)
  File.open(path, "w+") do |f|
    f.puts(data) if data.presence
  end
end

def expect_to_be_symlink(args)
  target = File.join(destination_root, args[:target])
  link = File.join(destination_root, args[:link])
  expect(File.exist?(link)).to eq true
  expect(File.lstat(link).symlink?).to eq true
  expect(File.readlink(link)).to eq target
end

def assert_directory_with_keep_file(dir)
  assert_directory dir
  assert_file File.join(dir, ".keep")
end
