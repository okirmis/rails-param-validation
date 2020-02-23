module RailsParamValidation

  class CustomTypeValidator < Validator
    def initialize(type)
      super type
      @validator = ValidatorFactory.create type.schema
    end

    def matches?(path, data)
      @validator.matches? path, data
    end

    def to_openapi
      { '$ref': "#/components/schemas/#{schema.type}" }
    end
  end

  class CustomTypeValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? AnnotationTypes::CustomT
    end

    def create(schema)
      CustomTypeValidator.new schema
    end
  end

end