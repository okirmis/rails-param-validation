module RailsParamValidation

  class BooleanValidator < Validator
    def initialize(schema)
      super schema
    end

    def matches?(path, data)
      if data.is_a?(TrueClass) || data.is_a?(FalseClass)
        return MatchResult.new data
      end

      case data
      when "true"
        return MatchResult.new true
      when "false"
        return MatchResult.new false
      else
        return MatchResult.new(nil, path, "Expected a boolean (true, false)")
      end
    end

    def to_openapi
      { type: :boolean }
    end
  end

  class BooleanValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == Boolean
    end

    def create(schema)
      BooleanValidator.new schema
    end
  end

end