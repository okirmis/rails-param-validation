require 'spec_helper'

module RailsParamValidation

  RSpec.describe ValidatorFactory do
    it "raises the correct exception if an unknown schema is encountered" do
      expect { ValidatorFactory.create Class }.to raise_error NoMatchingFactory
    end
  end

end