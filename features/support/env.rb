# simplecov must be loaded first as only files required after simplecov will show coverage data
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

require 'aruba/cucumber'