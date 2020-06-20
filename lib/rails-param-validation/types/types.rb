module RailsParamValidation

def self.register(type, schema)
  AnnotationTypes::CustomT.register type, schema
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
    AnnotationTypes::CustomT.new(type)
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
