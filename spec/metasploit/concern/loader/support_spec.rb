require 'spec_helper'

RSpec.describe 'Metasploit::Concern.run shared example' do
  subject(:instance) {
    described_class.new
  }

  #
  # lets
  #

  let(:described_class) {
    Class.new
  }

  let(:name) {
    "Namespace::RandomClassName#{SecureRandom.uuid.underscore.camelize}"
  }

  #
  # Callbacks
  #

  before(:example) do
    stub_const(name, described_class)

    described_class.class_eval do
      Metasploit::Concern.run(self)
    end
  end

  it_should_behave_like 'Metasploit::Concern.run'
end