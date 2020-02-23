module RailsParamValidation

  class ObjectValidator < Validator
    # @param [Hash] schema
    def initialize(schema)
      super schema

      @inner_validators = schema.map { |key, value| [key, ValidatorFactory.create(value)] }.to_h
    end

    def matches?(path, data)
      # Don't proceed if it is not hash at all
      unless data.is_a? Hash
        return MatchResult.new nil, path, "Expected an object"
      end

      value = {}
      result = MatchResult.new nil

      # Verify each entry
      @inner_validators.each do |property, validator|
        match = validator.matches?(path + [property], data.key?(property.to_s) ? data[property.to_s] : data[property.to_sym])

        if match.matches?
          value[property] = match.value
        else
          result.merge! match
        end
      end

      additional_properties = data.keys.reject { |k| @inner_validators.key?(k.to_s) || @inner_validators.key?(k.to_sym) }
      additional_properties.each do |property|
        result.merge! MatchResult.new(nil, path + [property], "Unknown property")
      end

      result.matches? ? MatchResult.new(value) : result
    end

    def to_openapi
      openapi = { type: :object, properties: {} }
      required = []
      schema.each do |key, _|
        validator = @inner_validators[key]
        openapi[:properties][key] = validator.to_openapi
        required.push key unless validator.is_a? OptionalValidator
      end

      openapi[:required] = required if required.any?
      openapi
    end
  end

  class ObjectValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? Hash
    end

    def create(schema)
      ObjectValidator.new schema
    end
  end

end