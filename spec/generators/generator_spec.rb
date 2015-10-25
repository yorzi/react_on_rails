# require "spec_helper"
require "generator_spec" # let's us use Rails's generator testing helpers but with RSpec syntax
require File.expand_path("../shared/shared_examples", __FILE__)
require File.expand_path("../../../lib/generators/react_on_rails/install_generator", __FILE__)
include ReactOnRails::Generators

describe InstallGenerator, type: :generator do
  destination File.expand_path("../../dummy-for-generators/", __FILE__)

  before do
    prepare_destination # this completely wipes the `destination` directory
    simulate_existing_file(".gitignore")
    simulate_existing_file("app/assets/javascripts/application.js")
    simulate_existing_file("Gemfile", nil)
    simulate_existing_file("config/routes.rb", "Rails.application.routes.draw do\nend\n")
  end

  context "no arguments" do
    before { run_generator }
    include_examples ":react"
    include_examples ":linters"
  end

  context "--with_server_rendering" do
    before { run_generator %w(--with-server-rendering) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
  end

  context "--with-redux" do
    before { run_generator %w(--with-redux) }
    include_examples ":react"
    include_examples ":linters"
    include_examples ":redux"
  end

  context "--with_redux --with-server-rendering" do
    before { run_generator %w(--with-redux --with-server-rendering) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":redux"
  end

  context "--with-hello-world-example" do
    before { run_generator %w(--with-hello-world-example) }
    include_examples ":react"
    include_examples ":linters"
    include_examples ":hello_world_example"
  end

  context "--with-hello-world-example --with-server-rendering" do
    before { run_generator %w(--with-hello-world-example --with-server-rendering) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":hello_world_example:server_rendering"
  end

  # # TODO
  # context "--with_redux --with_hello_world_example --with_server_rendering" do
  # end

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
end
