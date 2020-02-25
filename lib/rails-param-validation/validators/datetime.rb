module RailsParamValidation

  class DateTimeValidator < Validator
    def initialize(schema)
      super schema
    end

    def matches?(path, data)
      if data.is_a?(DateTime)
        MatchResult.new data
      elsif data.is_a?(Time)
        MatchResult.new data.to_datetime
      elsif data.is_a?(String)
        begin
          MatchResult.new(data.to_datetime || raise(ArgumentError))
        rescue ArgumentError
          MatchResult.new nil, path, "Expected a date-time"
        end
      else
        MatchResult.new nil, path, "Expected a date-time"
      end
    end

    def to_openapi
      { type: :string, format: 'date-time' }
    end
  end

  class DateTimeValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema == DateTime
    end

    def create(schema)
      DateTimeValidator.new schema
    end
  end

end