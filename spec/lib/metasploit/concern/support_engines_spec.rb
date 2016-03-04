class TestObject
  using SupportEngines
  def initialize

  end

  def get_engines
    return Rails.application.railties.engines()
  end
end

RSpec.describe SupportEngines do
  context "when used" do
    helper_object = TestObject.new()
    engines = helper_object.get_engines
    it "should not return nil" do
      expect(engines).to_not be_nil
    end

    it "should return an array of valid engines" do
      engines.each do |engine|
        expect(engine).to be_a(Rails::Engine)
      end
    end
  end
end

