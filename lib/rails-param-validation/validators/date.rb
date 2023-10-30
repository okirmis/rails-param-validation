module RailsParamValidation

  class DateValidator < Validator
    def initialize(schema, collection)
      super schema, collection
    end

    def matches?(path, data)
      if data.is_a?(DateTime)
        MatchResult.new data.to_date
      elsif data.is_a?(Time)
        MatchResult.new data.to_date
      elsif data.is_a?(String)
        begin
          MatchResult.new(data.to_date || raise(ArgumentError))
        rescue ArgumentError
          MatchResult.new nil, path, "Expected a date"
        end
      else
        MatchResult.new nil, path, "Expected a date"
      end
    end

    def to_openapi
      { type: :string, format: 'date' }
    end
  end

  class DateValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == Date
    end

    def create(schema, collection)
      DateValidator.new schema, collection
    end
  end

end