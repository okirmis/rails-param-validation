module RailsParamValidation

  class NoMatchingFactory < StandardError
    def initialize(schema)
      super "No matching factory found for schema: #{schema.inspect}"
    end
  end

end