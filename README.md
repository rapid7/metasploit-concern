# Metasploit::Concern [![Build Status](https://travis-ci.org/rapid7/metasploit-concern.png)](https://travis-ci.org/rapid7/metasploit-concern)[![Code Climate](https://codeclimate.com/github/rapid7/metasploit-concern.png)](https://codeclimate.com/github/rapid7/metasploit-concern)[![Coverage Status](https://coveralls.io/repos/rapid7/metasploit-concern/badge.png)](https://coveralls.io/r/rapid7/metasploit-concern)[![Dependency Status](https://gemnasium.com/rapid7/metasploit-concern.png)](https://gemnasium.com/rapid7/metasploit-concern)[![Gem Version](https://badge.fury.io/rb/metasploit-concern.png)](http://badge.fury.io/rb/metasploit-concern)

`Metasploit::Concern` allows you to define concerns in `app/concerns` that will automatically be included in matching
classes.  It can be used to automate adding new associations to `ActiveRecord::Base` models from gems and
`Rails::Engine`s.

## Versioning

`Metasploit::Concern` is versioned using [semantic versioning 2.0](http://semver.org/spec/v2.0.0.html).  Each branch
should set `Metasploit::Concern::Version::PRERELEASE` to the branch name, while master should have no `PRERELEASE`
and the `PRERELEASE` section of `Metasploit::Concern::VERSION` does not exist.

## Installation

Add this line to your application's `Gemfile`:

    gem 'metasploit-concern'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metasploit-concern

## Usage

### app/concerns

Add this line to your application's `config/application.rb`:

    config.paths.add 'app/concerns', autoload: true

Or if you're already using `config.autoload_paths +=`:

    config.autoload_paths += config.root.join('app', 'concerns')

### Concerns

Define concerns for class under `app/concerns` by creating files under directories named after the namespaced class
names:

    $ mkdir -p app/concerns/gem_namespace/gem_class
    $ edit app/concerns/gem_namespace/gem_class/my_concern.rb

Inside each concern, make sure the `module` name matches file name:

    module GemNamespace::GemClass::MyConcern
      ...
    end

Each concern is included using `Module#include` which means that the `included` method on each concern will be called.
Using `ActiveSupport::Concern` allow you to add new associations and or validations to `ActiveRecord::Base` subclass:

    module GemNamespace::GemClass::MyConcern
      extend ActiveSupport::Concern

      included do
        #
        # Associations
        #

        # @!attribute widgets
        #  Widgets for this gem_class.
        #
        #  @return [ActiveRecord::Relation<Widget>]
        has_many :widgets,
                 class_name: 'Widget',
                 dependent: :destroy,
                 inverse_of :gem_namespace_gem_class
      end
    end