# simplecov must be loaded first as only files required after simplecov will show coverage data
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter])

require 'aruba/cucumber'

if ['jruby', 'rbx'].include? RUBY_ENGINE
  Before do
    @aruba_timeout_seconds = 12
  end
end
