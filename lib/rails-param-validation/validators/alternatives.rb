module RailsParamValidation

class AlternativesValidator < Validator
    # @param [Array] schema
    def initialize(schema, collection)
      super schema, collection

      @inner_validators = schema.map { |value| ValidatorFactory.create(value, collection) }
      if @inner_validators.all? { |v| v.is_a?(ConstantValidator) }
        @inner_validators.sort_by! { |v| v.constant.to_s }
      end
    end

    def matches?(path, data)
      result = MatchResult.new nil, path, "The value did not match any of the alternatives"

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

    def to_openapi
      { oneOf: @inner_validators.map(&:to_openapi) }
    end
  end

  class AlternativesValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? Array
    end

    def create(schema, collection)
      AlternativesValidator.new schema, collection
    end
  end

end