require 'spec_helper'

RSpec.describe Metasploit::Concern::Loader do
  include Shoulda::Matchers::ActiveModel
  include Shoulda::Matchers::ActiveRecord

  shared_context 'Metasploit::Concern::ModuleWithConcerns' do
    let(:module_pathname) do
      root.join('metasploit', 'concern', 'module_with_concerns')
    end
  end

  shared_context 'Metasploit::Concern::ModuleWithConcerns::ConcernForModule' do
    include_context 'Metasploit::Concern::ModuleWithConcerns'

    #
    # lets
    #

    let(:concern_name) do
      "Metasploit::Concern::ModuleWithConcerns::#{concern_relative_name}"
    end

    let(:concern_relative_name) do
      'ConcernForModule'
    end

    let(:concern_pathname) do
      module_pathname.join("#{concern_relative_name.underscore}.rb")
    end

    let(:generate_concern_module) do
      concern_pathname.parent.mkpath

      concern_pathname.open('w') do |f|
        f.puts "module #{concern_name}"
        f.puts 'end'
      end
    end

    #
    # Callbacks
    #

    before(:example) do
      generate_concern_module
    end

    after(:example) do
      Rails.application.reloader.reload!
    end
  end

  subject(:loader) do
    described_class.new(
        root: root
    )
  end

  #
  # Methods
  #

  def remove_root
    if root.exist?
      root.rmtree
    end
  end

  def root
    Metasploit::Concern::Engine.root.join('spec', 'tmp')
  end

  #
  # lets
  #

  let(:load_path) do
    root.to_path
  end

  #
  # Callbacks
  #

  # clean up interrupted run
  before(:context) do
    remove_root
  end

  around(:example) do |example|
    loaded_features_before = $LOADED_FEATURES.dup

    begin
      example.run
    ensure
      $LOADED_FEATURES.replace(loaded_features_before)
    end
  end

  around(:example) do |example|
    load_path_before = $LOAD_PATH.dup

    begin
      example.run
    ensure
      $LOAD_PATH.replace(load_path_before)
    end
  end

  after(:example) do
    remove_root
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :root }
  end

  context '#constantize_pathname' do
    subject(:constantize_pathname) do
      loader.send(:constantize_pathname, pathname: descendant_pathname)
    end

    context 'with constant name' do
      include_context 'Metasploit::Concern::ModuleWithConcerns::ConcernForModule'

      let(:descendant_pathname) do
        concern_pathname
      end

      let(:test_loader) do
        Zeitwerk::Loader.new()
      end

      before(:example) do
        generate_concern_module

        $LOAD_PATH.unshift(load_path)
        test_loader.push_dir(load_path)
        test_loader.enable_reloading
        test_loader.setup

        my_load_paths = ActiveSupport::Dependencies.autoload_paths.dup
        my_load_paths << load_path
        ActiveSupport::Dependencies.autoload_paths = my_load_paths.freeze
      end

      after(:example) do
        test_loader.unload
        test_loader.unregister
      end

      it 'returns constant' do
        expect(constantize_pathname).not_to be_nil
        # don't use constant name directly to ensure that the loader is resolving the constant and not the test
        expect(constantize_pathname.name).to eq(concern_name)
      end
    end

    context 'without constant_name' do
      include_context 'Metasploit::Concern::ModuleWithConcerns'

      let(:invalid_extension) do
        '.rb.bak'
      end

      let(:descendant_pathname) do
        module_pathname.join("concern_for_module#{invalid_extension}")
      end

      it { is_expected.to be_nil }
    end
  end

  context '#each_pathname_constant' do
    include_context 'Metasploit::Concern::ModuleWithConcerns::ConcernForModule'

    #
    # Methods
    #

    def each_pathname_constant(&block)
      loader.each_pathname_constant(parent_pathname: module_pathname, &block)
    end

    #
    # Callbacks
    #

    let(:test_loader) do
      Zeitwerk::Loader.new()
    end

    before(:example) do
      generate_concern_module

      $LOAD_PATH.unshift(load_path)
      test_loader.push_dir(load_path)
      test_loader.enable_reloading
      test_loader.setup

      my_load_paths = ActiveSupport::Dependencies.autoload_paths.dup
      my_load_paths << load_path
      ActiveSupport::Dependencies.autoload_paths = my_load_paths.freeze
    end

    after(:example) do
      test_loader.unload
      test_loader.unregister
    end

    it 'yields concerns' do
      concern_names = []

      each_pathname_constant { |constant|
        concern_names << constant.name
      }

      expect(concern_names).to match_array([concern_name])
    end
  end

  context '#glob' do
    subject(:glob) do
      loader.glob
    end

    it { is_expected.to be_a Pathname }

    it 'is all .rb files under #root' do
      expect(glob).to eq(root.join('**', '*.rb'))
    end
  end

  context '#module_pathname_set' do
    subject(:module_pathname_set) do
      loader.module_pathname_set
    end

    let(:expected_module_pathnames) do
      Array.new(2) { |i|
        root.join('metasploit', 'concern', "module_with_concerns#{i}")
      }
    end

    let(:non_module_pathname) do
      root.join('metasploit', 'concern', 'module_without_concerns')
    end

    before(:example) do
      non_module_pathname.mkpath

      expected_module_pathnames.each do |expected_module_pathname|
        expected_module_pathname.mkpath
        concern_pathname = expected_module_pathname.join('concern_for_module.rb')

        concern_pathname.open('w') { |f|
          f.puts '# A concern'
        }
      end
    end

    it { is_expected.to be_a Set }

    it 'includes directories under #root that have .rb files' do
      expected_module_pathnames.each do |expected_module_pathname|
        expect(module_pathname_set).to include(expected_module_pathname)
      end
    end

    it 'does not include directories without .rb files' do
      expect(module_pathname_set).not_to include(non_module_pathname)
    end
  end

  context '#pathname_to_constant_name' do
    subject(:pathname_to_constant_name) do
      loader.send(:pathname_to_constant_name, descendant_pathname)
    end

    context 'extension' do
      let(:descendant_pathname) do
        root.join('metasploit', 'concern', 'module_with_concerns', "concern_for_module#{extension}")
      end

      context 'with .rb' do
        let(:extension) do
          '.rb'
        end

        it 'returns a valid constant name' do
          expect(pathname_to_constant_name).to eq('Metasploit::Concern::ModuleWithConcerns::ConcernForModule')
        end
      end

      context 'without .rb' do
        let(:extension) do
          '.rb.bak'
        end

        it { is_expected.to be_nil }
      end
    end
  end

  context '#register' do
    include_context 'Metasploit::Concern::ModuleWithConcerns::ConcernForModule'

    subject(:register) do
      loader.register
    end

    context 'with base class ActiveSupport::Dependencies.autoloaded?' do
      before(:example) do
        module_pathname.parent.mkpath

        open("#{module_pathname}.rb", 'w') do |f|
          f.puts "class Metasploit::Concern::ModuleWithConcerns"
          f.puts "  ActiveSupport.run_load_hooks(:metasploit_concern_module_with_concerns, self)"
          f.puts "end"
        end
      end

      let(:test_loader) do
        Zeitwerk::Loader.new()
      end

      before(:example) do
        generate_concern_module

        $LOAD_PATH.unshift(load_path)
        test_loader.push_dir(load_path)
        test_loader.enable_reloading
        test_loader.setup

        my_load_paths = ActiveSupport::Dependencies.autoload_paths.dup
        my_load_paths << load_path
        ActiveSupport::Dependencies.autoload_paths = my_load_paths.freeze
      end

      after(:example) do
        test_loader.unload
        test_loader.unregister
      end

      context 'false' do
        #
        # Callbacks
        #

        before(:example) do
          Metasploit::Concern.autoload :ModuleWithConcerns, 'metasploit/concern/module_with_concerns.rb'
        end

        after(:example) do
          Metasploit::Concern.send(:remove_const, :ModuleWithConcerns)
        end

        it 'has base class loaded' do
          expect {
            Metasploit::Concern::ModuleWithConcerns
          }.not_to raise_error

          expect(Metasploit::Concern::ModuleWithConcerns).to be_a Class
        end

        it 'includes concerns' do
          register
          expect(Metasploit::Concern::ModuleWithConcerns.ancestors.map(&:name)).to include(concern_name)
        end

        it 'does not end up with two copies of concern when reloaded' do
          register

          Metasploit::Concern::ModuleWithConcerns
          expect(Metasploit::Concern::ModuleWithConcerns.ancestors.map(&:name).count(concern_name)).to eq(1)

          expect {
            Rails.application.reloader.reload!
          }.not_to change {
                 Metasploit::Concern::ModuleWithConcerns.constants.include? concern_relative_name.to_sym
               }

          Metasploit::Concern::ModuleWithConcerns.send(
              :include,
              Metasploit::Concern::ModuleWithConcerns::ConcernForModule
          )

          expect(Metasploit::Concern::ModuleWithConcerns.ancestors.map(&:name).count(concern_name)).to eq(1)
        end
      end

      context 'true' do

        it 'has base class loaded' do
          expect {
            Metasploit::Concern::ModuleWithConcerns
          }.not_to raise_error

          expect(Metasploit::Concern::ModuleWithConcerns).to be_a Class
        end

        it 'includes concerns' do
          register
          expect(Metasploit::Concern::ModuleWithConcerns.ancestors.map(&:name)).to include(concern_name)
        end

        it 'does not end up with two copies of concern when reloaded and included' do
          register

          Metasploit::Concern::ModuleWithConcerns
          expect(Metasploit::Concern::ModuleWithConcerns.ancestors.map(&:name).count(concern_name)).to eq(1)

          Rails.application.reloader.reload!

          Metasploit::Concern::ModuleWithConcerns.send(
              :include,
              Metasploit::Concern::ModuleWithConcerns::ConcernForModule
          )

          expect(Metasploit::Concern::ModuleWithConcerns.ancestors.map(&:name).count(concern_name)).to eq(1)
        end
      end
    end

    # rspec run with Rails loaded for Rails::Engine, so no need to stub Rails
    context 'with Rails' do

      def unloadable_constants
        unloadable = []
        Zeitwerk::Registry.loaders.each do |loader|
          unloadable += loader.unloadable_cpaths
        end
        unloadable
      end

      context 'with development' do
        #
        # lets
        #

        let(:env) do
          ActiveSupport::StringInquirer.new('development')
        end

        #
        # Callbacks
        #

        before(:example) do
          allow(Rails).to receive(:env).and_return(env)
          Zeitwerk::Registry.loaders.each do |loader|
            loader.reload
          end
        end

        it 'does not add module with concerns to unloadable constants because it would causes required classes to no be reloaded' do
          register

          expect(unloadable_constants).not_to include('Metasploit::Concern::ModuleWithConcerns')
        end
      end

      # rspec run under test environment, so no need to stub Rails.env
      context 'without development' do
        it 'does not add module with concerns to unloadable constants' do
          register

          expect(unloadable_constants).not_to include('Metasploit::Concern::ModuleWithConcerns')
        end
      end
    end
  end
end
