# Metasploit::Concern [![Build Status](https://travis-ci.org/rapid7/metasploit-concern.png)](https://travis-ci.org/rapid7/metasploit-concern)[![Code Climate](https://codeclimate.com/github/rapid7/metasploit-concern.png)](https://codeclimate.com/github/rapid7/metasploit-concern)[![Coverage Status](https://coveralls.io/repos/rapid7/metasploit-concern/badge.png)](https://coveralls.io/r/rapid7/metasploit-concern)[![Dependency Status](https://gemnasium.com/rapid7/metasploit-concern.png)](https://gemnasium.com/rapid7/metasploit-concern)[![Gem Version](https://badge.fury.io/rb/metasploit-concern.png)](http://badge.fury.io/rb/metasploit-concern)

`Metasploit::Concern` allows you to define concerns in `app/concerns` that will automatically be included in matching classes.  It can be used to automate adding new associations to `ActiveRecord::Base` models from gems and `Rails::Engine`s.

## Versioning

`Metasploit::Concern` is versioned using [semantic versioning 2.0](http://semver.org/spec/v2.0.0.html).  Each branch should set `Metasploit::Concern::Version::PRERELEASE` to the branch SUMMARY, while master should have no `PRERELEASE` and the `PRERELEASE` section of `Metasploit::Concern::VERSION` does not exist.

## Installation

Add this line to your application's `Gemfile`:

    gem 'metasploit-concern'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metasploit-concern

## Supporting concerns

`Metasploit::Concern` support is a cooperative effort that involves the classes from the gem being setup to allow downstream dependents to inject concerns.

In order for `Metasploit::Concern` to load concerns for `app/concerns`, the class on which `Module#include` will be called must support `ActiveSupport` load hooks with a specific name format.  You can run the appropriate load hooks at the bottom of the class body:

    class GemNamespace::GemClass < ActiveRecord::Base
      # class body

      Metasploit::Concern.run(self)
    end

### Testing

Include the shared examples from `Metasploit::Concern` in your `spec_helper.rb`:


    Dir[Metasploit::Concern.root.join("spec/support/**/*.rb")].each do |f|
      require f
    end


To verify that your classes call `Metasploit::Concern.run` correctly, you can use the `'Metasploit::Concern.run'` shared example:

    # spec/app/models/gem_namespace/gem_class_spec.rb
    describe GemNamespace::GemClass do
      it_should_behave_like 'Metasploit::Concern.run'
    end

## Using concerns

Concerns are added in downstream dependents of gems that support concerns.  These dependents can be a `Rails::Engines` or full `Rails::Application`.

### app/concerns

#### Rails::Application

Add this line to your application's `config/application.rb`:

    config.paths.add 'app/concerns', autoload: true

Or if you're already using `config.autoload_paths +=`:

    config.autoload_paths += config.root.join('app', 'concerns')

#### Rails::Engine

Add this line to your engine's class body:

    module EngineNamespace
      class Engine < ::Rails::Engine
        config.paths.add 'app/concerns', autoload: true
      end
    end

### Concerns

Define concerns for class under `app/concerns` by creating files under directories named after the namespaced class names:

    $ mkdir -p app/concerns/gem_namespace/gem_class
    $ edit app/concerns/gem_namespace/gem_class/my_concern.rb

Inside each concern, make sure the `module` name matches file name:

    module GemNamespace::GemClass::MyConcern
      ...
    end

Each concern is included using `Module#include` which means that the `included` method on each concern will be called.  Using `ActiveSupport::Concern` allow you to add new associations and or validations to `ActiveRecord::Base` subclass:

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
    
### initializers

`Metasploit::Concern::Engine` defines the `'metasploit_concern.load_concerns'` initializer, which sets up `ActiveSupport.on_load` callbacks.  If you depend on a feature from a concern in your initializers, it is best to have the initializer declare that it needs to be run after `'metasploit_concern.load_concerns`:

    initializer 'application_or_engine_namespace.depends_on_concerns', after: 'metasploit_concern.load_concerns' do
      if GemNamespace::GemClass.primary.widgets.empty?
        logger.info('No Widgets on the primary GemClass!')
      end
    end

## Contributing

### Forking

[Fork this repository](https://github.com/rapid7/metasploit-concern/fork)

### Branching

Branch names follow the format `TYPE/ISSUE/SUMMARY`.  You can create it with `git checkout -b TYPE/ISSUE/SUMMARY`.

#### `TYPE`

`TYPE` can be `bug`, `chore`, or `feature`.

#### `ISSUE`

`ISSUE` is either a [Github issue](https://github.com/rapid7/metasploit-concern/issues) or an issue from some other
issue tracking software.

#### `SUMMARY`

`SUMMARY` is is short summary of the purpose of the branch composed of lower case words separated by '-' so that it is a valid `PRERELEASE` for the Gem version.

### Changes

#### `PRERELEASE`

1. Update `PRERELEASE` to match the `SUMMARY` in the branch name.  If you branched from `master`, and [version.rb](lib/metasploit/concern/version.rb) does not have `PRERELEASE` defined, then adding the following lines after `PATCH`: 
```
# The prerelease version, scoped to the {PATCH} version number.
PRERELEASE = '<SUMMARY>'
```
2. `rake spec`
3.  Verify the specs pass, which indicates that `PRERELEASE` was updated correctly.
4. Commit the change `git commit -a`


#### Your changes

Make your changes or however many commits you like, commiting each with `git commit`.

#### `VERSION`

Following the rules for [semantic versioning 2.0](http://semver.org/spec/v2.0.0.html), update [`MINOR`](lib/metasploit/concern/version.rb) and [`PATCH`](lib/metasploit/concern/version.rb) and commit the changes.

##### Compatible changes

If your change are compatible with the previous branch's API, then increment [`PATCH`](lib/metasploit/concern/version.rb).

##### Incompatible changes

If your changes are incompatible with the previous branch's API, then increment
[`MINOR`](lib/metasploit/concern/version.rb) and reset [`PATCH`](lib/metasploit/concern/version.rb) to `0`.

#### Pre-Pull Request Testing

1. Run specs one last time before opening the Pull Request: `rake spec`
2. Verify there was no failures.

#### Push

Push your branch to your fork on gitub: `git push push TYPE/ISSUE/SUMMARY`

#### Pull Request

* [Create new Pull Request](https://github.com/rapid7/metasploit-concern/compare/)
* Add a Verification Steps comment

```
# Verification Steps

- [ ] `bundle install`

## `rake spec`
- [ ] `rake spec`
- [ ] VERIFY no failures
```
You should also include at least one scenario to manually check the changes outside of specs.

* Add a Post-merge Steps comment

The 'Post-merge Steps' are a reminder to the reviewer of the Pull Request of how to update the [`PRERELEASE`](lib/metasploit/concern/version.rb) so that [version_spec.rb](spec/lib/metasploit/concern/version_spec.rb) passes on the target branch after the merge.

DESTINATION is the name of the destination branch into which the merge is being made.  SOURCE_SUMMARY is the SUMMARY from TYPE/ISSUE/SUMMARY branch name for the SOURCE branch that is being made.

When merging to `master`:

```
# Post-merge Steps

Perform these steps prior to pushing to master or the build will be broke on master.

## Version
- [ ] Edit `lib/metasploit/concern/version.rb`
- [ ] Remove `PRERELEASE` and its comment as `PRERELEASE` is not defined on master.

## Gem build
- [ ] gem build *.gemspec
- [ ] VERIFY the gem has no '.pre' version suffix.

## RSpec
- [ ] `rake spec`
- [ ] VERIFY version examples pass without failures

## Commit & Push
- [ ] `git commit -a`
- [ ] `git push origin master`
```

When merging to DESTINATION other than `master`:

```
# Post-merge Steps

Perform these steps prior to pushing to DESTINATION or the build will be broke on DESTINATION.

## Version
- [ ] Edit `lib/metasploit/concern/version.rb`
- [ ] Change `PRELEASE` from `SOURCE_SUMMARY` to `DESTINATION_SUMMARY` to match the branch (DESTINATION) summary (DESTINATION_SUMMARY)

## Gem build
- [ ] gem build *.gemspec
- [ ] VERIFY the prerelease suffix has change on the gem.

## RSpec
- [ ] `rake spec`
- [ ] VERIFY version examples pass without failures

## Commit & Push
- [ ] `git commit -a`
- [ ] `git push origin DESTINATION`
```

* Add a 'Release Steps' comment

The 'Release Steps' are a reminder to the reviewer of the Pull Request of how to release the gem.

```
# Release

Complete these steps on DESTINATION

### JRuby
- [ ] `rvm use jruby@metasploit-concern`
- [ ] `rm Gemfile.lock`
- [ ] `bundle install`
- [ ] `rake release`

## MRI Ruby
- [ ] `rvm use ruby-1.9.3@metasploit-concern`
- [ ] `rm Gemfile.lock`
- [ ] `bundle install`
- [ ] `rake release`
```

#### Downstream dependencies

When releasing new versions, the following projects may need to be updated:

* [metasploit_data_models](https://github.com/rapid7/metasploit_data_models)
* [metasploit-credential](https://github.com/rapid7/metasploit-credential)
* [metasploit-framework](https://github.com/rapid7/metasploit-framework)
* [metasploit-pro-ui](https://github.com/rapid7/pro/tree/master/ui)
* [metasploit-pro-engine](https://github.com/rapid7/pro/tree/master/engine)
* [firewall_egress](https://github.com/rapid7/pro/tree/master/metamodules/firewall_egress)