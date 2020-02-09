require 'spec_helper'

module RailsParamValidation

  RSpec.describe BooleanValidator do
    before(:all) do
      @validator = ValidatorFactory.create(Boolean)
    end

    it 'should accept valid booleans' do
      match = @validator.matches?([], true)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(true)

      match = @validator.matches?([], false)

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(false)
    end

    it 'should accept strings representing valid booleans' do
      match = @validator.matches?([], "true")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(true)

      match = @validator.matches?([], "false")

      expect(match.matches?).to eq(true)
      expect(match.value).to eq(false)
    end

    it 'should not accept strings except for true and false' do
      match = @validator.matches?([], "1")

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a boolean (true, false)" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept arrays' do
      match = @validator.matches?([], [])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a boolean (true, false)" }])
      expect(match.value).to eq(nil)

      match = @validator.matches?([], [true])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a boolean (true, false)" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept objects' do
      match = @validator.matches?([], {})

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a boolean (true, false)" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept integers' do
      match = @validator.matches?([], 1)

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a boolean (true, false)" }])
      expect(match.value).to eq(nil)
    end

  end
end

