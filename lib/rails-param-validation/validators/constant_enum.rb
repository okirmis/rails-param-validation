module RailsParamValidation
  class ConstantEnumValidator < Validator
    def initialize(schema, collection)
      super schema, collection
      @constants = schema
    end

    def matches?(path, data)
      detected_values = @constants.select { |c| c.to_s == data.to_s }
      unless detected_values.any?
        return MatchResult.new(nil, path, "The value is not one of the allowed constants")
      end

      MatchResult.new detected_values.first, path
    end

    def to_openapi
      ValidatorFactory.create(
        ConstantValidator::CLASS_MAP.fetch(
          @constants.first.class,
          @constants.first.class
        ),
        collection
      ).to_openapi.merge(enum: @constants)
    end
  end

end