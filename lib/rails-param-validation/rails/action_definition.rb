module RailsParamValidation

  class ActionDefinition
    attr_reader :params

    def initialize
      @params = {}
    end

    def add_param(name, schema, default, description)
      @params[name] = {
          schema: schema,
          default: default,
          description: description
      }
    end

    def to_schema
      @params.map { |k, v| [k, v[:schema]] }.to_h
    end
  end

end
