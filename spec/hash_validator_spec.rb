require 'spec_helper'

module RailsParamValidation

  RSpec.describe HashValidator do
    before(:all) do
      @validator = ValidatorFactory.create(HashType(Integer, Integer))
    end

    it 'should accept valid hashes' do
      match = @validator.matches?([], { 23 => 42, 1337 => 1337 })

      expect(match.matches?).to eq(true)
      expect(match.value).to eq({ 23 => 42, 1337 => 1337 })
    end

    it 'should convert convertible hashes' do
      match = @validator.matches?([], { "23" => "42", "1337" => "1337" })

      expect(match.matches?).to eq(true)
      expect(match.value).to eq({ 23 => 42, 1337 => 1337 })
    end

    it 'should reject hashes with non-matching values' do
      match = @validator.matches?([], { "23" => "42.5", "1337" => "1337" })

      expect(match.matches?).to eq(false)
      expect(match.value).to eq(nil)
    end

    it 'should reject hashes with non-matching keys' do
      match = @validator.matches?([], { "23.5" => "42", "1337" => "1337" })

      expect(match.matches?).to eq(false)
      expect(match.value).to eq(nil)
    end

    it 'should reject non-hashes' do
      match = @validator.matches?([], "abc")

      expect(match.matches?).to eq(false)
      expect(match.value).to eq(nil)
    end

  end
end

