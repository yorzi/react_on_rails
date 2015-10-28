require File.expand_path("../../support/generator_spec_helper", __FILE__)

describe InstallGenerator, type: :generator do
  destination File.expand_path("../../dummy-for-generators/", __FILE__)

  context "no args" do
    before(:all) { run_generator_test_with_args(%w()) }
    include_examples ":react"
    include_examples ":linters"
    include_examples ":hello_world_example"
  end

  context "--server-rendering" do
    before(:all) { run_generator_test_with_args(%w(--server-rendering)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":hello_world_example:server_rendering"
  end

  context "-S" do
    before(:all) { run_generator_test_with_args(%w(-S)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":hello_world_example:server_rendering"
  end

  context "--redux" do
    before(:all) { run_generator_test_with_args(%w(--redux)) }
    include_examples ":react:base"
    include_examples ":linters"
    include_examples ":redux:base"
  end

  context "-d" do
    before(:all) { run_generator_test_with_args(%w(-d)) }
    include_examples ":react:base"
    include_examples ":linters"
    include_examples ":redux:base"
  end

  context "--skip-hello-world-example" do
    before(:all) { run_generator_test_with_args(%w(--skip-hello-world-example)) }
    include_examples ":react"
    include_examples ":linters"
  end

  context "-H" do
    before(:all) { run_generator_test_with_args(%w(-H)) }
    include_examples ":react"
    include_examples ":linters"
  end

  context "--server_rendering --skip-hello-world-example" do
    before(:all) { run_generator_test_with_args(%w(--server-rendering --skip-hello-world-example)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
  end

  context "-S -H" do
    before(:all) { run_generator_test_with_args(%w(-S -H)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
  end

  context "--redux --server_rendering" do
    before(:all) { run_generator_test_with_args(%w(--redux --server-rendering)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":hello_world_example:server_rendering"
    include_examples ":redux:server_rendering"
  end

  context "-d -S" do
    before(:all) { run_generator_test_with_args(%w(-d -S)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":hello_world_example:server_rendering"
    include_examples ":redux:server_rendering:hello_world_example"
  end

  context "--redux --skip-hello-world-example" do
    before(:all) { run_generator_test_with_args(%w(--redux --skip-hello-world-example)) }
    include_examples ":react"
    include_examples ":linters"
    include_examples ":redux:base"
  end

  context "-d -H" do
    before(:all) { run_generator_test_with_args(%w(-d -H)) }
    include_examples ":react"
    include_examples ":linters"
    include_examples ":redux:base"
  end

  context "--redux --server-rendering --skip-hello-world-example" do
    before(:all) { run_generator_test_with_args(%w(--redux --server-rendering --skip-hello-world-example)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":redux:base"
  end

  context "-d -S -H" do
    before(:all) { run_generator_test_with_args(%w(-d -S -H)) }
    include_examples ":react:server_rendering"
    include_examples ":linters"
    include_examples ":redux:base"
  end
end
