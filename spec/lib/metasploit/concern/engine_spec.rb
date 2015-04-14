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

      context 'with engine' do
        context "with 'app/concerns'" do
          #
          # lets
          #

          let(:application) {
            Class.new(Rails::Engine)
          }

          let(:context) {
            Object.new
          }

          let(:load_concerns) {
            described_class.initializers.find { |initializer|
              initializer.name == "metasploit_concern.load_concerns"
            }.bind(context)
          }

          #
          # Callbacks
          #

          before(:each) do
            stub_const('EngineUnderTest', engine)

            railties = double(engines: [engine])

            allow(application).to receive(:railties).and_return(railties)
            allow(Rails).to receive(:application).and_return(application)
          end

          context 'with `eager_load: true`' do
            let(:engine) {
              Class.new(Rails::Engine) do
                config.paths.add 'app/concerns', eager_load: true
              end
            }

            it 'raises Metasploit::Concern::Error::EagerLoad' do
              expect {
                load_concerns.run
              }.to raise_error Metasploit::Concern::Error::EagerLoad,
                               "#{engine}'s `app/concerns` is marked as `eager_load: true`.  This will cause " \
                               "circular dependency errors when the concerns are loaded.  Declare `app/concerns` to " \
                               "stop it from inheriting `eager_load: true` from `app`: \n" \
                               "\n" \
                               "  class #{engine} < Rails::Engine\n" \
                               "    config.paths.add 'app/concerns', autoload: true\n" \
                               "  end\n"
            end
          end

          context 'without `eager_load: true`' do
            context 'with `autoload: true`' do
              let(:engine) {
                Class.new(Rails::Engine) do
                  config.paths.add 'app/concerns', autoload: true
                end
              }

              it 'does not raise error' do
                expect {
                  load_concerns.run
                }.not_to raise_error
              end
            end

            context 'without `autoload: true`' do
              let(:engine) {
                Class.new(Rails::Engine) do
                  config.paths.add 'app/concerns'
                end
              }

              it 'raises Metasploit::Concern::Error::SkipAutoLoad' do
                expect {
                  load_concerns.run
                }.to raise_error Metasploit::Concern::Error::SkipAutoload,
                                 "#{engine}'s `app/concerns` is marked as `autoload: false`.  Declare `app/concerns` " \
                                 "as autoloading:\n" \
                                 "\n" \
                                 "  class #{engine} < Rails::Engine\n" \
                                 "    config.paths.add 'app/concerns', autoload: true\n" \
                                 "  end\n"
              end
            end
          end
        end
      end
    end
  end
end