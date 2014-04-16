$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'metasploit/concern/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'metasploit-concern'
  s.version     = Metasploit::Concern::VERSION
  s.authors     = ['Luke Imhoff']
  s.email       = ['luke_imhoff@rapid7.com']
  s.homepage    = 'https://github.com/rapid7/metasploit-concern'
  s.license     = 'BSD-3-clause'
  s.summary     = 'Automatically include Modules from app/concerns'
  s.description = 'Automatically includes Modules from app/concerns/<module_with_concerns>/<concern>.rb into ' \
                  '<module_with_concerns> to ease monkey-patching associations and validations on ActiveRecord::Base ' \
                  'descendents from other gems when layering schemas.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']

  # documentation
  s.add_development_dependency 'yard'

  # uses ActiveSupport.on_load to include concerns
  s.add_runtime_dependency 'activesupport'

  if RUBY_PLATFORM =~ /java/
    # markdown formatting for yard
    s.add_development_dependency 'kramdown'

    s.platform = Gem::Platform::JAVA
  else
    # markdown formatting for yard
    s.add_development_dependency 'redcarpet'

    s.platform = Gem::Platform::RUBY
  end
end
