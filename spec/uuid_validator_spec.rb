require 'spec_helper'

module RailsParamValidation

  RSpec.describe UuidValidator do
    before(:all) do
      @validator = ValidatorFactory.create(Uuid)
    end

    it 'should accept valid uuids' do
      %w(92a176d8-22a1-4455-9394-71e5d5e777f9 d0051d44-d0fd-4229-b128-7e8a26eb3019 730fe219-c92b-40da-93ba-72f2d8f000e4).each do |uuid|
        match = @validator.matches?([], uuid)

        expect(match.matches?).to eq(true)
        expect(match.value).to eq(uuid)
      end
    end

    it 'should accept valid uuids represented as symbols' do
      [
          :"92a176d8-22a1-4455-9394-71e5d5e777f9",
          :"d0051d44-d0fd-4229-b128-7e8a26eb3019",
          :"730fe219-c92b-40da-93ba-72f2d8f000e4"
      ].each do |uuid|
        match = @validator.matches?([], uuid)

        expect(match.matches?).to eq(true)
        expect(match.value).to eq(uuid.to_s)
      end
    end

    it 'should not accept strings no following the correct format' do
      match = @validator.matches?([], "671fa8c6ee7e4cc3ae8efa8e513be2ec")

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "String does not match a uuid v4 scheme" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept integers' do
      match = @validator.matches?([], 42)

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a uuid (v4)" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept arrays' do
      match = @validator.matches?([], [])

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a uuid (v4)" }])
      expect(match.value).to eq(nil)
    end

    it 'should not accept hashes' do
      match = @validator.matches?([], {})

      expect(match.matches?).to eq(false)
      expect(match.errors).to eq([{ path: [], message: "Expected a uuid (v4)" }])
      expect(match.value).to eq(nil)
    end

  end
end

