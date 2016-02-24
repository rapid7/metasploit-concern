module SupportEngines

  refine Rails::Engine::Railties do
    def engines
      # method that returns all current engines
      @engines ||= ::Rails::Engine.subclasses.map(&:instance)
    end
  end
end