module RailsParamValidation

  class TypeNotFound < StandardError
    def initialize(type)
      super("The following type was not found: #{type}")
    end
  end

end
