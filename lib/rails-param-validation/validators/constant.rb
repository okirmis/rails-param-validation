module RailsParamValidation

  class ConstantValidator < Validator
    CLASS_MAP = { TrueClass => Boolean, FalseClass => Boolean }

    def initialize(schema)
      super schema

      @constant = schema
    end

    def matches?(path, data)

      if data.to_s == @constant.to_s
        if @constant.is_a?(String)
          MatchResult.new @constant.clone
        else
          MatchResult.new @constant
        end
      else
        MatchResult.new nil, path, "Expected value #{@constant.to_s}"
      end
    end

    def to_openapi
      ValidatorFactory.create(CLASS_MAP.fetch(schema.class, schema.class)).to_openapi.merge(enum: [schema])
    end
  end

  class ConstantValidatorFactory < ValidatorFactory
    def supports?(schema)
      ![String, Symbol, Numeric, TrueClass, FalseClass].detect { |klass| schema.is_a? klass }.nil?
    end

    def create(schema)
      ConstantValidator.new schema
    end
  end

end