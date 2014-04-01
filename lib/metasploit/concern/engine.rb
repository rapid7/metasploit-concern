begin
  require 'rails'
rescue LoadError => error
  warn "rails could not be loaded, so Metasploit::Concern::Engine will not be defined: #{error}"
else
  module Metasploit
    module Concern
      class Engine < ::Rails::Engine
        # @see http://viget.com/extend/rails-engine-testing-with-rspec-capybara-and-factorygirl
        config.generators do |g|
          g.assets false
          g.helper false
          g.test_framework :rspec, fixture: false
        end

        isolate_namespace Metasploit::Concern
      end
    end
  end
end
