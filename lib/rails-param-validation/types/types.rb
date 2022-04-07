module RailsParamValidation

def self.register(type, schema)
  AnnotationTypes::CustomT.register(
      Types::Namespace.with_namespace(Types::Namespace.fetch(Types::Namespace.caller_file), type),
      schema
  )
end

module AnnotationTypes
class AnnotationT
  attr_reader :inner_type

  def initialize(inner_type)
    @inner_type = inner_type
  end
end

class ArrayT < AnnotationT
  def initialize(inner_type)
    super(inner_type)
  end
end

class HashT < AnnotationT
  attr_reader :key_type

  def initialize(inner_type, key_type = String)
    super(inner_type)

    @key_type = key_type
  end
end

class OptionalT < AnnotationT
  attr_reader :default

  def initialize(inner_type, default)
    super(inner_type)

    @default = default
  end
end

class CustomT < AnnotationT
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def schema
    CustomT.registry[@type]
  end

  def self.register(type, schema)
    registry[type] = schema
  end

  def self.registered(type)
    raise TypeNotFound.new(type) unless registry.key? type
    registry[type]
  end

  def self.types
    registry.keys
  end

  private

  def self.registry
    @@types ||= {}
  end
end
end

module Types
  class Namespace
    def self.store(scope, namespace)
      map[scope] = namespace
    end

    def self.fetch(scope)
      path = scope.split('/')

      (path.size - 1).times do
        key = path.join '/'
        return map[key] if map.key? key

        path.pop
      end
    end

    def self.caller_file
      caller_locations(2, 1)[0].path
    end

    def self.with_namespace(namespace, type)
      if namespace
        path = namespace.to_s.split('.')

        while type.start_with?("_")
          type = type[1..-1]
          path.pop
        end

        "#{path.join(".")}.#{type}".to_sym
      else
        type
      end
    end

    class << self
      protected

      def map
        @map ||= { '' => nil }
      end
    end
  end

  def FileNamespace(namespace)
    Namespace.store Namespace.caller_file, namespace
  end

  def DirectoryNamespace(namespace)
    Namespace.store File.dirname(caller_locations(1, 1)[0].path), namespace
  end

  def ArrayType(inner_type)
    AnnotationTypes::ArrayT.new(inner_type)
  end

  def HashType(inner_type, key_type = String)
    AnnotationTypes::HashT.new(inner_type, key_type)
  end

  def Optional(inner_type, default)
    AnnotationTypes::OptionalT.new(inner_type, default)
  end

  def Type(type)
    AnnotationTypes::CustomT.new(Namespace.with_namespace(Namespace.fetch(Namespace.caller_file), type))
  end
end

end

begin
  class Boolean; end unless Module.const_get("Boolean").is_a?(Class)
rescue NameError
  class Boolean; end
end

begin
  class Uuid; end unless Module.const_get("Uuid").is_a?(Class)
rescue NameError
  class Uuid; end
end
