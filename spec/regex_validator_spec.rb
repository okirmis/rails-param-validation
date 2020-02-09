require 'spec_helper'

module RailsParamValidation

  RSpec.describe RegexValidator do
    before(:all) do
      @validator = ValidatorFactory.create(/X=[0-9]+/)
    end

    it 'should accept valid strings' do
      %w(X=123 X=0 X=12).each do |str|
        match = @validator.matches?([], str)

        expect(match.matches?).to eq(true)
        expect(match.value).to eq(str)
      end
    end

    it 'should accept valid symbols representing matching strings' do
      [
          :"X=123",
          :"X=0",
          :"X=12"
      ].each do |str|
        match = @validator.matches?([], str)

        expect(match.matches?).to eq(true)
        expect(match.value).to eq(str.to_s)
      end
    end

    it 'should reject non-full matches' do
      %w(ABCX=123DE X=0B AX=12).each do |str|
        match = @validator.matches?([], str)

        expect(match.matches?).to eq(false)
        expect(match.value).to eq(nil)
      end
    end

    it 'should not accept strings no following the correct format' do
      match = @validator.matches?([], "y=12")

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "String does not match the required pattern" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept integers' do
      match = @validator.matches?([], 42)

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a string matching the given pattern" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept arrays' do
      match = @validator.matches?([], [])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a string matching the given pattern" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept hashes' do
      match = @validator.matches?([], {})

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a string matching the given pattern" }])
      expect(match.value).to eq(nil)
    end

  end
end

