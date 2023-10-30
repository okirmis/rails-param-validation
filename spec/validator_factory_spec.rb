require 'spec_helper'

module RailsParamValidation

  RSpec.describe ValidatorFactory do
    it "raises the correct exception if an unknown schema is encountered" do
      expect { ValidatorFactory.create Class }.to raise_error NoMatchingFactory
    end

    it "accepts a custom collection of factories" do
      default_collection = ValidatorFactory.collection.clone
      without_integer = FactoryCollection.new(
        default_collection.factories.reject { |factory| factory.is_a?(IntegerValidatorFactory) }
      )

      expect { ValidatorFactory.create(Integer, default_collection) }.not_to raise_error
      expect { ValidatorFactory.create(Integer, without_integer) }.to raise_error NoMatchingFactory
    end
  end

end