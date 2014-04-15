module Dummy::ModelWithConcern::ConcernForModel
  extend ActiveSupport::Concern

  included do
    @instance_variable_from_concern = true
  end

  module ClassMethods
    def class_method_from_concern

    end
  end

  def instance_method_from_concern

  end
end