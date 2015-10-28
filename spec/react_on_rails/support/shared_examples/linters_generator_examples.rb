shared_examples ":linters" do
  it "adds linter gems" do
    match = <<-MATCH.strip_heredoc

      group :development do
        gem 'rubocop'
        gem 'scss_lint'
        gem 'ruby-lint'
      end
    MATCH

    assert_file("Gemfile", match)
  end

  it "copies linter config files" do
    assert_file "client/.eslintrc"
    assert_file "client/.eslintignore"
    assert_file "client/.jscsrc"
  end

  it "copies linting and auditing tasks" do
    assert_file "lib/tasks/brakeman.rake"
    assert_file "lib/tasks/ci.rake"
    assert_file "lib/tasks/linters.rake"
  end
end
