module RailsParamValidation

  class CustomTypeValidator < Validator
    def initialize(type, collection)
      super type, collection
    end

    def matches?(path, data)
      ValidatorFactory.create(schema.schema, collection).matches? path, data
    end

    def to_openapi
      { '$ref': "#/components/schemas/#{schema.type}" }
    end
  end

  class CustomTypeValidatorFactory < ValidatorFactory
    def supports?(schema)
      schema.is_a? AnnotationTypes::CustomT
    end

    def create(schema, collection)
      CustomTypeValidator.new schema, collection
    end
  end

end