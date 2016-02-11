require 'spec_helper'

RSpec.describe Metasploit::Concern do
  context 'CONSTANTS' do
    context 'VERSION' do
      subject(:version) do
        described_class::VERSION
      end

      it 'is Metasploit::Concern::Version.full' do
        expect(version).to eq(Metasploit::Concern::Version.full)
      end
    end
  end
end