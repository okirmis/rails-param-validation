module RailsParamValidation

  class StringValidator < Validator
    def initialize(schema)
      super schema
    end

    def matches?(path, data)
      if data.is_a?(String) || data.is_a?(Numeric) || data.is_a?(TrueClass) || data.is_a?(FalseClass)
        MatchResult.new data.to_s
      else
        MatchResult.new nil, path, "Expected a string"
      end
    end
  end

  class StringValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == String
    end

    def create(schema)
      StringValidator.new schema
    end
  end

end