source 'https://rubygems.org'

# Declare your gem's dependencies in metasploit-concern.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Temporary, remove once the Rails 7.1 update is complete
# see: https://stackoverflow.com/questions/79360526/uninitialized-constant-activesupportloggerthreadsafelevellogger-nameerror
gem 'concurrent-ruby', '1.3.4'

group :development do
  # documentation
  gem 'yard'
  gem 'redcarpet', platforms: :ruby
  gem 'kramdown', platforms: :jruby
end

group :development, :test do
  # rails is not used because activerecord should not be included, but rails would normally coordinate the versions
  # between its dependencies, which is now handled by this constraint.
  # @todo MSP-9654

  # Dummy app uses actionpack for ActionController, but not rails since it doesn't use activerecord.
  gem 'actionpack'
  # Engine tasks are loaded using railtie
  gem 'railties'
  # running documentation generation tasks and rspec tasks
  gem 'rake'
  # Used for Sql Lite Db
  gem 'sqlite3', '~> 1.7'
  # provides a complete suite of testing facilities supporting TDD, BDD, mocking, and benchmarking.
  gem "minitest"
  gem 'rspec-rails'
  # defines time zones for activesupport.  Must be explicit since it is normally implicit with activerecord
  gem 'tzinfo'
end

group :test do
  # Test the 'Metasploit::Concern.run' shared example
  gem 'aruba'
  # Test the 'Metasploit::Concern.run' shared example
  gem 'cucumber'
  # add matchers from shoulda, such as validates_presence_of, which are useful for testing validations
  # Version 2.6.0 has a bug when ActiveRecord is not available
  # @see https://github.com/thoughtbot/shoulda-matchers/issues/480
  gem 'shoulda-matchers'
  # code coverage of tests
  gem 'simplecov', :require => false
end
