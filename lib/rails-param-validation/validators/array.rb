module RailsParamValidation

  class ArrayValidator < Validator
    # @param [ArrayT] schema
    def initialize(schema)
      super schema

      @inner_validator = ValidatorFactory.create schema.inner_type
    end

    def matches?(path, data)
      # Don't proceed if it is not an array at all
      unless data.is_a? Array
        return MatchResult.new nil, path, "Expected an array"
      end

      value = []
      result = MatchResult.new nil

      # Verify each entry
      data.each_with_index do |entry, index|
        match = @inner_validator.matches?(path + [index.to_s], entry)

        if match.matches?
          value.push match.value
        else
          result.merge! match
        end
      end

      result.matches? ? MatchResult.new(value) : result
    end
  end

  class ArrayValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? AnnotationTypes::ArrayT
    end

    def create(schema)
      ArrayValidator.new schema
    end
  end

end