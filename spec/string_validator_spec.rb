require 'spec_helper'

module RailsParamValidation

  RSpec.describe StringValidator do
    before(:all) do
      @validator = ValidatorFactory.create(String)
    end

    it 'should accept strings' do
      match = @validator.matches?([], "John Doe")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq("John Doe")
    end

    it 'should accept empty strings' do
      match = @validator.matches?([], "")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq("")
    end

    it 'should accept integers' do
      match = @validator.matches?([], 42)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq("42")
    end

    it 'should accept floats' do
      match = @validator.matches?([], 42.5)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq("42.5")
    end

    it 'should accept booleans' do
      match = @validator.matches?([], true)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq("true")

      match = @validator.matches?([], false)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq("false")
    end

    it 'should not accept arrays' do
      match = @validator.matches?([], [])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a string" }])
      expect(match.value).to eq(nil)

      match = @validator.matches?([], ["John Doe"])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a string" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept objects' do
      match = @validator.matches?([], {})

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a string" }])
      expect(match.value).to eq(nil)
    end

  end
end

