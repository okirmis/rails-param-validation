require 'spec_helper'

module RailsParamValidation

  RSpec.describe OptionalValidator do
    before(:all) do
      @validator = ValidatorFactory.create(Optional(Integer, 42))
    end

    it 'should accept valid inner types' do
      match = @validator.matches?([], "1337")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(1337)

      match = @validator.matches?([], 1337)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(1337)
    end

    it 'should use a default value if nil is passed' do
      match = @validator.matches?([], nil)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(42)
    end

    it 'should reject non-matching types' do
      match = @validator.matches?([], [])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)

      match = @validator.matches?([], [nil])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected an integer" }])
      expect(match.value).to eq(nil)
    end

  end
end

