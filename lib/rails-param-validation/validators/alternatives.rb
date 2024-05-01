module RailsParamValidation
class AlternativesValidator < Validator
    # @param [Array] schema
    def initialize(schema, collection)
      schema = AlternativesValidator.simplify schema
      super schema, collection

      @inner_validators = []

      previous_enum_values = nil
      schema.each do |value|
        validator = ValidatorFactory.create(value, collection)
        if validator.is_a?(ConstantValidator)
          if previous_enum_values.nil?
            previous_enum_values = [value]
          else
            if validator.constant.class == previous_enum_values.first.class
              previous_enum_values << value
            else
              @inner_validators << ConstantEnumValidator.new(previous_enum_values, collection)
              previous_enum_values = [value]
            end
          end

          next
        end

        if previous_enum_values
          @inner_validators << ConstantEnumValidator.new(previous_enum_values, collection)
          previous_enum_values = nil
        end
        @inner_validators << validator
      end

      @inner_validators << ConstantEnumValidator.new(previous_enum_values, collection) if previous_enum_values
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
      if @inner_validators.size == 1
        return @inner_validators.first.to_openapi
      end

      { oneOf: @inner_validators.map(&:to_openapi) }
    end

    protected

    def self.simplify(schema)
      alternatives = []

      schema.each do |sub_schema|
        if sub_schema.is_a?(Array)
          alternatives += sub_schema
        else
          alternatives << sub_schema
        end
      end

      alternatives
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