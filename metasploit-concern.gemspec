$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'metasploit/concern/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'metasploit-concern'
  s.version     = Metasploit::Concern::VERSION
  s.authors     = ['Metasploit Hackers']
  s.email       = ['msfdev@metasploit.com']
  s.homepage    = 'https://github.com/rapid7/metasploit-concern'
  s.license     = 'BSD-3-clause'
  s.summary     = 'Automatically include Modules from app/concerns'
  s.description = 'Automatically includes Modules from app/concerns/<module_with_concerns>/<concern>.rb into ' \
                  '<module_with_concerns> to ease monkey-patching associations and validations on ActiveRecord::Base ' \
                  'descendents from other gems when layering schemas.'

  s.files = Dir['{app,config,lib}/**/*'] + ['CONTRIBUTING.md', 'LICENSE', 'Rakefile', 'README.md'] + Dir['spec/support/**/*.rb']


  s.required_ruby_version = '>= 2.7.0'

  s.add_development_dependency 'metasploit-yard'
  s.add_development_dependency 'metasploit-erd'

  # uses ActiveSupport.on_load to include concerns
  # it is only defined in version 3.0.0 and newer
  s.add_runtime_dependency 'activemodel', '~> 7.0'
  s.add_runtime_dependency 'activesupport', '~> 7.0'
  # for engine
  s.add_runtime_dependency 'railties', '~> 7.0'
  s.add_runtime_dependency 'zeitwerk'
end
