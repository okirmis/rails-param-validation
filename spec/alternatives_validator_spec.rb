require 'spec_helper'

module RailsParamValidation

  RSpec.describe AlternativesValidator do
    before(:all) do
      @validator = ValidatorFactory.create([Integer, Boolean, ArrayType(Boolean)])
    end

    it 'should accept valid entries for all options' do
      match = @validator.matches?([], 42)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(42)

      match = @validator.matches?([], true)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(true)

      match = @validator.matches?([], [false])

      expect(match.matches?).to eq(true)
      expect(match.value).to eq([false])
    end

    it 'should convert arguments for all options if possible' do
      match = @validator.matches?([], "42")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(42)

      match = @validator.matches?([], "true")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(true)

      match = @validator.matches?([], ["false"])

      expect(match.matches?).to eq(true)
      expect(match.value).to eq([false])
    end

    it 'should fail if none of the options matches' do
      match = @validator.matches?([], ["42"])

      expect(match.matches?).to eq(false)
      expect(match.value).to eq(nil)
    end

  end
end

