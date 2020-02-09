require 'spec_helper'

module RailsParamValidation

RSpec.describe ObjectValidator do
  before(:all) do
    @validator = ValidatorFactory.create({ name: String, amount: Float })
  end

  it 'should accept valid hashes' do
    match = @validator.matches?([], name: "John Doe", amount: 42.0)

    expect(match.matches?).to eq(true)
    expect(match.value).to eq(name: "John Doe", amount: 42.0)
  end

  it 'should reject hashes with missing keys' do
    match = @validator.matches?([], name: "John Doe")

    expect(match.matches?).to eq(false)
    expect(match.value).to eq(nil)
    expect(match.errors).to eq([{ path: [:amount], message: "Expected a float" }])
  end

  it 'should reject hashes with additional keys' do
    match = @validator.matches?([], name: "John Doe", amount: 42.0, age: 23)

    expect(match.matches?).to eq(false)
    expect(match.value).to eq(nil)
    expect(match.errors).to eq([{ path: [:age], message: "Unknown property" }])
  end

  it 'should return symbols as keys if schema defines symbols if strings are given' do
    match = @validator.matches?([], "name" => "John Doe", "amount" => 42.0)

    expect(match.errors).to eq([])
    expect(match.matches?).to eq(true)
    expect(match.value).to eq({ name: "John Doe", amount: 42.0 })
  end

  it 'should return symbols as keys if schema defines symbols if symbols are given' do
    match = @validator.matches?([], name: "John Doe", amount: 42.0)

    expect(match.errors).to eq([])
    expect(match.matches?).to eq(true)
    expect(match.value).to eq({ name: "John Doe", amount: 42.0 })
  end

  it 'should return strings as keys if schema defines strings if strings are given' do
    @validator = ValidatorFactory.create({ "name" => String, "amount" => Float })
    match = @validator.matches?([], "name" => "John Doe", "amount" => 42.0)

    expect(match.errors).to eq([])
    expect(match.matches?).to eq(true)
    expect(match.value).to eq({ "name" => "John Doe", "amount" => 42.0 })
  end

  it 'should return strings as keys if schema defines strings if symbols are given' do
    @validator = ValidatorFactory.create({ "name" => String, "amount" => Float })
    match = @validator.matches?([], name: "John Doe", amount: 42.0)

    expect(match.errors).to eq([])
    expect(match.matches?).to eq(true)
    expect(match.value).to eq({ "name" => "John Doe", "amount" => 42.0 })
  end

  it 'should not accept strings' do
    match = @validator.matches?([], "John Doe")

    expect(match.matches?).to eq(false)
    expect(match.errors).to eq([{ path: [], message: "Expected an object" }])
    expect(match.value).to eq(nil)
  end


  it 'should not accept arrays' do
    match = @validator.matches?([], [])

    expect(match.matches?).to eq(false)
    expect(match.errors).to eq([{ path: [], message: "Expected an object" }])
    expect(match.value).to eq(nil)
  end


  it 'should not accept floats' do
    match = @validator.matches?([], 42.5)

    expect(match.matches?).to eq(false)
    expect(match.errors).to eq([{ path: [], message: "Expected an object" }])
    expect(match.value).to eq(nil)
  end

end

end