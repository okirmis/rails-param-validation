module RailsParamValidation

  class UuidValidator < Validator
    REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

    def initialize(schema)
      super schema
    end

    def matches?(path, data)
      if data.is_a?(String) || data.is_a?(Symbol)
        data = data.to_s
        match = data.match REGEX
        if match
          return MatchResult.new data
        else
          return MatchResult.new nil, path, "String does not match a uuid v4 scheme"
        end
      else
        MatchResult.new nil, path, "Expected a uuid (v4)"
      end
    end
  end

  class UuidValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == Uuid
    end

    def create(schema)
      UuidValidator.new schema
    end
  end

end