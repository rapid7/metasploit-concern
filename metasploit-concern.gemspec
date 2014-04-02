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
  s.summary     = ''
  s.description = ''

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']

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
