module RailsParamValidation

  class HashValidator < Validator
    # @param [HashT] schema
    def initialize(schema)
      super schema

      @value_validator = ValidatorFactory.create schema.inner_type
      @key_validator = ValidatorFactory.create schema.key_type
    end

    def matches?(path, data)
      # Don't proceed if it is not an array at all
      unless data.is_a? Hash
        return MatchResult.new nil, path, "Expected a hash"
      end

      value = {}
      result = MatchResult.new nil

      # Verify each entry
      data.each do |key, entry|
        match_key = @key_validator.matches?(path + ["#{key}[key]"], key)
        match_value = @value_validator.matches?(path + [key], entry)

        if match_value.matches? && match_key.matches?
          value[match_key.value] = match_value.value
        else
          result.merge! match_key unless match_key.matches?
          result.merge! match_value unless match_value.matches?
        end
      end

      result.matches? ? MatchResult.new(value) : result
    end

    def to_openapi
      { type: :object, additionalProperties: @value_validator.to_openapi }
    end
  end

  class HashValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? AnnotationTypes::HashT
    end

    def create(schema)
      HashValidator.new schema
    end
  end

end