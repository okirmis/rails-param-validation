module RailsParamValidation

  class OptionalValidator < Validator
    def initialize(schema)
      super schema

      @inner_validator = ValidatorFactory.create schema.inner_type
      @default         = schema.default
    end

    def matches?(path, data)
      if data.nil?
        MatchResult.new @default
      else
        @inner_validator.matches? path, data
      end
    end
  end

  class OptionalValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? AnnotationTypes::OptionalT
    end

    def create(schema)
      OptionalValidator.new schema
    end
  end

end