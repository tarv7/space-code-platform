require 'rails_helper' 

describe "Factory Bot" do
  FactoryBot.factories.map(&:name).each do |factory_name|
    describe "#{factory_name} factory" do
      # Test each factory
      it "is valid" do
        factory = FactoryBot.build(factory_name)

        expect(factory).to be_valid
      end

      # Test each trait
      FactoryBot.factories[factory_name].definition.defined_traits.map(&:name).each do |trait_name|
        context "with trait #{trait_name}" do
          it "is valid" do
            factory = FactoryBot.build(factory_name, trait_name)

            expect(factory).to be_valid
          end
        end
      end
    end 
  end
end