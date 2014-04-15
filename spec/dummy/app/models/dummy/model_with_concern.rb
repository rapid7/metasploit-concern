class Dummy::ModelWithConcern
  ActiveSupport.run_load_hooks(:dummy_model_with_concern, self)
end