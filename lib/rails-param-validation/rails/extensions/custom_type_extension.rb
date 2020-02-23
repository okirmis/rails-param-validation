module RailsParamValidation
  module CustomTypesExtension
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def declare(type, schema)
        RailsParamValidation::AnnotationTypes::CustomT.register type, schema
      end
    end
  end
end
