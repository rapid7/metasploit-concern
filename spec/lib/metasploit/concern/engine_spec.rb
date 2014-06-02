require 'spec_helper'

describe Metasploit::Concern::Engine do
  context 'initializers' do
    context 'metasploit_concern.load_concerns' do
      it 'includes concerns' do
        expect(Dummy::ModelWithConcern.instance_variable_defined?(:@instance_variable_from_concern)).to eq(true)
        expect(Dummy::ModelWithConcern).to respond_to :class_method_from_concern

        instance = Dummy::ModelWithConcern.new
        expect(instance).to be_a Dummy::ModelWithConcern::ConcernForModel
        expect(instance).to respond_to :instance_method_from_concern
      end
    end
  end
end