require "simplecov"
SimpleCov.start do
  filters.clear
  add_filter { |src| src.filename.match?(/spec\/.*_spec.rb/) }
end

require "bundler/setup"
require "rails-param-validation"

include RailsParamValidation::Types

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
