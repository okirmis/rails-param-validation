module RailsParamValidation

  class FloatValidator < Validator
    def initialize(schema)
      super schema
    end

    def matches?(path, data)
      if data.is_a? Numeric
        return MatchResult.new data.to_f
      end

      unless data.is_a? String
        return MatchResult.new(nil, path, "Expected a float")
      end

      begin
        return MatchResult.new(Float(data))
      rescue ArgumentError
        return MatchResult.new(nil, path, "Expected a float")
      end
    end

    def to_openapi
      { type: :number, format: :double }
    end
  end

  class FloatValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == Float
    end

    def create(schema)
      FloatValidator.new schema
    end
  end

end