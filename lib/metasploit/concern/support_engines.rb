# Ruby refinement.
module SupportEngines

  refine Rails::Engine::Railties do
    # Reimplementing ‘Rails::Application::Railties#Engines since it has been removed.
    def engines
      # method that returns all current engines
      @engines ||= ::Rails::Engine.subclasses.map(&:instance)
    end
  end
end