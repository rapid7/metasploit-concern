require 'spec_helper'

RSpec.describe Metasploit::Concern do
  context 'CONSTANTS' do
    context 'VERSION' do
      subject(:version) {
        described_class::VERSION
      }

      it 'is Metasploit::ERD::Version.full' do
        expect(version).to eq(Metasploit::Concern::VERSION)
      end
    end
  end
end