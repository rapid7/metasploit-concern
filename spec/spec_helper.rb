# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

# Require simplecov before loading ..dummy/config/environment.rb because it will cause metasploit_data_models/lib to
# be loaded, which would result in Coverage not recording hits for any of the files.
require 'simplecov'
require 'coveralls'

if ENV['TRAVIS'] == 'true'
  # don't generate local report as it is inaccessible on travis-ci, which is why coveralls is being used.
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
else
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      # either generate the local report
      SimpleCov::Formatter::HTMLFormatter
  ]
end

require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# full backtrace in logs so its easier to trace errors
Rails.backtrace_cleaner.remove_silencers!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Metasploit::Concern::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = :random
end
