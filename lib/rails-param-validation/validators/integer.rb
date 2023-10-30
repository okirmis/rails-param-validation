module RailsParamValidation

  class IntegerValidator < Validator
    def initialize(schema, collection)
      super schema, collection
    end

    def matches?(path, data)
      if data.is_a? Integer
        return MatchResult.new data
      end

      unless data.is_a? String
        return MatchResult.new(nil, path, "Expected an integer")
      end

      begin
        return MatchResult.new(Integer(data))
      rescue ArgumentError
        return MatchResult.new(nil, path, "Expected an integer")
      end
    end

    def to_openapi
      { type: :integer }
    end
  end

  class IntegerValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == Integer
    end

    def create(schema, collection)
      IntegerValidator.new schema, collection
    end
  end

end