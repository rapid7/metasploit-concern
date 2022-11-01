require 'spec_helper'

RSpec.describe Metasploit::Concern::Engine do
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
          }.bind(RSpec.context)
        }

        #
        # Callbacks
        #

        before(:example) do
          stub_const('ApplicationUnderTest', application)
          stub_const('EngineUnderTest', engine)

          railties = double(_all: [engine.instance])

          allow(application).to receive(:railties).and_return(railties)
          allow(Rails).to receive(:application).and_return(application)
        end

        context "with 'app/concerns'" do
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
              #
              # lets
              #

              let(:engine) {
                root = self.root

                Class.new(Rails::Engine) do
                  config.root = root
                  config.paths.add 'app/concerns', autoload: true
                end
              }

              let(:root) {
                Pathname.new(Dir.mktmpdir)
              }

              #
              # Callbacks
              #

              before(:example) do
                root.join('app', 'concerns').mkpath
              end

              after(:example) do
                root.rmtree
              end

              it 'does not raise error' do
                expect {
                  load_concerns.run
                }.not_to raise_error
              end

              it "registers concern load via ActiveSupport::Reloader.to_prepare for for engine's app/concerns" do
                expect(ActiveSupport::Reloader).to receive(:to_prepare)
                load_concerns.run
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

        context "without 'app/concerns'" do
          #
          # lets
          #

          let(:engine) {
            root = self.root

            Class.new(Rails::Engine) do
              config.root = root
            end
          }

          let(:root) {
            Pathname.new(Dir.mktmpdir)
          }

          #
          # Callbacks
          #

          before(:example) do
            root.join('app', 'concerns').mkpath
          end

          after(:example) do
            root.rmtree
          end

          it "does not create Metasploit::Concern::Loader for engine's <root>/app/concerns" do
            expect(Metasploit::Concern::Loader).not_to receive(:new)

            load_concerns.run
          end
        end
      end
    end
  end
end
