module RailsParamValidation

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
end

module Types
  def ArrayType(inner_type)
    AnnotationTypes::ArrayT.new(inner_type)
  end

  def HashType(inner_type, key_type = String)
    AnnotationTypes::HashT.new(inner_type, key_type)
  end
end

end
