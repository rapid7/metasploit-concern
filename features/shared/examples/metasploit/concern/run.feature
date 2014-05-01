Feature: 'Metasploit::Concern::Loader support' shared example

  The 'Metasploit::Concern::Loader support' shared example will check that the described_class for an RSpec *_spec.rb
  file properly calls `ActiveSupport.run_load_hooks(<name>, self) with the proper <name> symbol and self.

  Background:
    Given a file named "background.rb" with:
    """ruby
    require 'metasploit/concern'
    require Metasploit::Concern.root.join('spec', 'support', 'shared', 'examples', 'metasploit', 'concern', 'run.rb')
    """
  Scenario: ActiveSupport.run_load_hooks called with correct name and base
    Given a file named "run_spec.rb" with:
    """ruby
    load 'background.rb'

    class ClassUsingMetasploitConcernRun
      Metasploit::Concern.run(self)
    end

    RSpec.describe ClassUsingMetasploitConcernRun do
      it_should_behave_like 'Metasploit::Concern.run'
    end
    """
    When I run `rspec run_spec.rb -f doc`
    Then the output should match:
      """
      ClassUsingMetasploitConcernRun
        it should behave like Metasploit::Concern.run
          with correct base
            calls ActiveSupport.run_load_hooks with correct load hook name
          with correct load hook name
            calls ActiveSupport.run_load_hooks with correct base
      .*
      2 examples, 0 failures
      """
  Scenario: ActiveSupport.run_load_hooks called with correct base, but wrong name
    Given a file named "wrong_name_spec.rb" with:
    """ruby
    load 'background.rb'

    module Namespace
      class ClassWithWrongLoadHookName
        ActiveSupport.run_load_hooks(:'namespace/class_with_wrong_load_hook_name', self)
       end
    end

    RSpec.describe Namespace::ClassWithWrongLoadHookName do
      it_should_behave_like 'Metasploit::Concern.run'
    end
    """
    When I run `rspec wrong_name_spec.rb -f doc`
    Then the output should contain:
      """
      [:"namespace/class_with_wrong_load_hook_name"] to include :namespace_class_with_wrong_load_hook_name
      """
  Scenario: ActiveSupport.run_load_hooks called with correct name, but wrong base
    Given a file named "wrong_base_spec.rb" with:
    """ruby
    load 'background.rb'

    module ClassWithWrongBase
      ActiveSupport.run_load_hooks(:class_with_wrong_base)
    end

    RSpec.describe ClassWithWrongBase do
      it_should_behave_like 'Metasploit::Concern.run'
    end
    """
    When I run `rspec wrong_base_spec.rb -f doc`
    Then the output should contain "expected [Object] to include ClassWithWrongBase"
