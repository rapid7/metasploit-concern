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
  # Rails 8.0 upgrade: widened from '~> 7.0' (which means >= 7.0, < 8.0) to
  # '>= 7.0', '< 8.1' so this gem resolves with both Rails 7.x and 8.0.
  # The old pessimistic constraint hard-blocked Bundler from pulling Rails 8.
  s.add_runtime_dependency 'activemodel', '>= 7.0', '< 8.1'
  s.add_runtime_dependency 'activesupport', '>= 7.0', '< 8.1'
  # for engine
  s.add_runtime_dependency 'railties', '>= 7.0', '< 8.1'
  s.add_runtime_dependency 'zeitwerk'

  # Standard libraries: https://www.ruby-lang.org/en/news/2023/12/25/ruby-3-3-0-released/
  %w[
    drb
    mutex_m
  ].each do |library|
    s.add_runtime_dependency library
  end
end
