module RailsParamValidation

  class StringValidator < Validator
    def initialize(schema, collection)
      super schema, collection
    end

    def matches?(path, data)
      if data.is_a?(String) || data.is_a?(Symbol) || data.is_a?(Numeric) || data.is_a?(TrueClass) || data.is_a?(FalseClass)
        MatchResult.new data.to_s
      else
        MatchResult.new nil, path, "Expected a string"
      end
    end

    def to_openapi
      { type: :string }
    end
  end

  class StringValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == String || schema == Symbol
    end

    def create(schema, collection)
      StringValidator.new schema, collection
    end
  end

end