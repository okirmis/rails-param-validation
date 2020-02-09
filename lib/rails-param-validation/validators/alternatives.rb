module RailsParamValidation

class AlternativesValidator < Validator
    # @param [Array] schema
    def initialize(schema)
      super schema

      @inner_validators = schema.map { |value| ValidatorFactory.create(value) }
    end

    def matches?(path, data)
      result = MatchResult.new nil

      @inner_validators.each_with_index do |validator, idx|
        match = validator.matches?(path + ["[#{idx}]"], data)

        if match.matches?
          return match
        else
          result.merge! match
        end
      end

      result
    end
  end

  class AlternativesValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? Array
    end

    def create(schema)
      AlternativesValidator.new schema
    end
  end

end