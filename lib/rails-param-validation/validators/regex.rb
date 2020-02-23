module RailsParamValidation

  class RegexValidator < Validator
    def initialize(schema)
      super schema
    end

    def matches?(path, data)
      if data.is_a?(String) || data.is_a?(Symbol)
        data = data.to_s
        match = data.match self.schema
        if match && match.to_s.size == data.size
          return MatchResult.new data
        else
          return MatchResult.new nil, path, "String does not match the required pattern"
        end
      else
        MatchResult.new nil, path, "Expected a string matching the given pattern"
      end
    end

    def to_openapi
      { type: :string, pattern: self.schema.source }
    end
  end

  class RegexValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? Regexp
    end

    def create(schema)
      RegexValidator.new schema
    end
  end

end