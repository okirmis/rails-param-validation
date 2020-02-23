module RailsParamValidation

  class ActionDefinition
    attr_reader :params, :request_body_type, :paths, :responses, :controller, :action
    attr_accessor :description

    def initialize
      @params = {}
      @paths = []
      @param_validation_enabled = true
      @description = ''
      @request_body_type = RailsParamValidation.config.default_body_content_type
      @responses = {}
    end

    def store_origin!(controller, action)
      @controller = controller
      @action = action
    end

    def disable_param_validation!
      @param_validation_enabled = false
    end

    def param_validation?
      @param_validation_enabled
    end

    def request_body_type!(mime)
      @request_body_type = mime
    end

    def add_param(name, type, schema, description)
      @params[name] = {
          schema: schema,
          description: description,
          type: type
      }
    end

    def add_response(status, name, schema, description)
      @responses[status] = {
          name: name,
          schema: schema,
          description: description
      }
    end

    def add_path(method, path)
      @paths.push(method: method, path: path)
    end

    def finalize!(class_name, method_name)
      @responses.each do |code, response|
        name = "#{class_name.to_s.capitalize}#{method_name.to_s.capitalize}#{Rack::Utils::SYMBOL_TO_STATUS_CODE.key(code).to_s.camelize}Response".to_sym
        AnnotationTypes::CustomT.register(name, response[:schema])

        response.merge!(schema: AnnotationTypes::CustomT.new(name))
      end
    end

    def to_schema
      @params.map { |k, v| [k, v[:schema]] }.to_h
    end
  end

end
