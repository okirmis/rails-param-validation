require 'spec_helper'

module RailsParamValidation

  RSpec.describe IntegerValidator do
    before(:all) do
      @validator = ValidatorFactory.create(Integer)
    end

    it 'should accept valid integers' do
      match = @validator.matches?([], 42)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(42)
    end

    it 'should accept strings representing valid integers' do
      match = @validator.matches?([], "42")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(42)
    end

    it 'should not accept strings not representing integers' do
      match = @validator.matches?([], "42ab")

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept arrays' do
      match = @validator.matches?([], [])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)

      match = @validator.matches?([], [42])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept objects' do
      match = @validator.matches?([], {})

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept booleans' do
      match = @validator.matches?([], false)

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)

      match = @validator.matches?([], true)

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept valid floats' do
      match = @validator.matches?([], 42.5)

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept strings representing valid floats' do
      match = @validator.matches?([], "42.5")

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)
    end
  end
end

