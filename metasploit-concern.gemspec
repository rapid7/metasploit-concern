$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'metasploit/concern/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'metasploit-concern'
  s.version     = Metasploit::Concern::GEM_VERSION
  s.authors     = ['Luke Imhoff']
  s.email       = ['luke_imhoff@rapid7.com']
  s.homepage    = 'https://github.com/rapid7/metasploit-concern'
  s.license     = 'BSD-3-clause'
  s.summary     = 'Automatically include Modules from app/concerns'
  s.description = 'Automatically includes Modules from app/concerns/<module_with_concerns>/<concern>.rb into ' \
                  '<module_with_concerns> to ease monkey-patching associations and validations on ActiveRecord::Base ' \
                  'descendents from other gems when layering schemas.'

  s.files = Dir['{app,config,lib}/**/*'] + ['CONTRIBUTING.md', 'LICENSE', 'Rakefile', 'README.md'] + Dir['spec/support/**/*.rb']
  
  rails_version_constraints = ['>= 4.0.9', '< 4.1.0']
  
  # uses ActiveSupport.on_load to include concerns
  # it is only defined in version 3.0.0 and newer
  s.add_runtime_dependency 'activerecord', *rails_version_constraints
  s.add_runtime_dependency 'activesupport', *rails_version_constraints
end
