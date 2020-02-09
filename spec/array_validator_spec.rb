require 'spec_helper'

module RailsParamValidation

  RSpec.describe ArrayValidator do
    before(:all) do
      @validator = ValidatorFactory.create(ArrayType(Integer))
    end

    it 'should accept valid arrays of valid inner types' do
      match = @validator.matches?([], [42, 23, 1337])

      expect(match.matches?).to eq(true)
      expect(match.value).to eq([42, 23, 1337])
    end

    it 'should accept empty arrays' do
      match = @validator.matches?([], [])

      expect(match.matches?).to eq(true)
      expect(match.value).to eq([])
    end

    it 'should accept convert inner types' do
      match = @validator.matches?([], %w(42 23 1337))

      expect(match.matches?).to eq(true)
      expect(match.value).to eq([42, 23, 1337])
    end

    it 'should accept mixed inner types if convertible' do
      match = @validator.matches?([], [42, "23", "1337"])

      expect(match.matches?).to eq(true)
      expect(match.value).to eq([42, 23, 1337])
    end

    it 'should reject non-array-types' do
      ["", {}, 42, true, [[]]].each do |value|
        match = @validator.matches?([], value)

        expect(match.matches?).to eq(false)
        expect(match.value).to eq(nil)
      end
    end

    it 'should not accept arrays with at least one not-convertible type' do
      match = @validator.matches?([], [42, "43", "a"])

      expect(match.matches?).to eq(false)
      expect(match.value).to eq(nil)
    end

  end
end

