# Only include the Rails engine when using Rails.  This is for compatibility with metasploit-framework.
if defined? Rails
  require 'metasploit/concern/engine'
end

# Shared namespace for metasploit gems; used in {https://github.com/rapid7/metasploit-concern metasploit-concern},
# {https://github.com/rapid7/metasploit-framework metasploit-framework}, and
# {https://github.com/rapid7/metasploit-model metasploit-model}
module Metasploit
  # Automates the inclusion of concerns into classes and models from other `Rail::Engine`s by use of an app/concerns
  # directory in the `Rails::Engine` that declares the concerns.
  #
  # The `Class` or `Module` must support the use of concerns by calling ActiveSupport.run_load_hooks with a symbol equal
  # to the underscore of its name with any '/' replaced with underscores also.
  #
  # @example engine_that_supports_concerns/app/models/model_that_supports_concerns.rb
  #   class EngineThatSupportsConcerns::ModelThatSupportsConcerns
  #     # declared as last statement in body so that concerns can redefine everything in class
  #     ActiveSupport.run_load_hooks(:engine_that_supports_concerns_model_that_supports_concerns, self)
  #   end
  #
  # To include concerns from a Rails::Application add 'app/concerns' to paths and then declare concerns under
  # app/concerns.
  #
  # @example config/application.rb
  #   config.paths.add 'app/concerns', autoload: true
  #
  # @example Concern declared in application
  #   # app/concerns/engine_that_supports_concerns/model_that_supports_concerns/concern_from_application.rb
  #   module EngineThatSupportsConcerns::ModelThatSupportsConcerns::ConcernFromApplication
  #     extend ActiveSupport::Concern
  #
  #     included do
  #       # run with self equal to EngineThatSupportsConcerns::ModelThatSupportsConcerns, but at the end of the class
  #       # definition, instead of at the beginning as would be the case with
  #       #   class EngineThatSupportsConcerns::ModelThatSupportsConcerns
  #       #     include EngineThatSupportsConcerns::ModelThatSupportsConcerns::ModelThatSupportsConcerns
  #       #
  #       #     # body
  #       #   end
  #     end
  #   end
  #
  # To include concerns from a Rails::Engine add 'app/concerns' to the paths and then declare concerns under
  # app/concerns.
  #
  # @example Rails::Engine configuration for app/concerns
  #   # engine_defining_concerns/lib/engine_defining_concerns/engine.rb
  #   module EngineDefiningConcerns
  #     class Engine < Rails::Engine
  #       config.paths.add 'app/concerns', autoload: true
  #     end
  #   end
  #
  # @example Concern declared in Rails::Engine
  #   # engine_defining_concerns/app/concerns
  #   module EngineThatSupportsConcerns::ModelThatSupportsConcerns::ConcernFromEngine
  #     extend ActiveSupport::Concern
  #
  #     included do
  #       # run with self equal to EngineThatSupportsConcerns::ModelThatSupportsConcerns, but at the end of the class
  #       # definition, instead of at the beginning as would be the case with
  #       #   class EngineThatSupportsConcerns::ModelThatSupportsConcerns
  #       #     include EngineThatSupportsConcerns::ModelThatSupportsConcerns::ModelThatSupportsConcerns
  #       #
  #       #     # body
  #       #   end
  #     end
  #   end
  module Concern

  end
end
