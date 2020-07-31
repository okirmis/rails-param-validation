module RailsParamValidation
  module CustomTypesExtension
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def declare(type, schema)
        namespace = Types::Namespace.fetch(Types::Namespace.caller_file)
        RailsParamValidation::AnnotationTypes::CustomT.register Types::Namespace.with_namespace(namespace, type), schema
      end
    end
  end
end
