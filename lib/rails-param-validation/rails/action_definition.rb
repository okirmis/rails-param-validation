module RailsParamValidation

  class ActionDefinition
    attr_reader :params, :request_body_type, :paths, :responses, :controller, :action, :security, :source_file
    attr_accessor :description

    def initialize(source_file)
      @params = {}
      @paths = []
      @param_validation_enabled = true
      @description = ''
      @request_body_type = RailsParamValidation.config.default_body_content_type if defined?(Rails)
      @responses = {}
      @flags = {}
      @source_file = source_file
      @security = []
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

    def add_security(security)
      @security.push(security.is_a?(Hash) ? security : { security => [] })
    end

    def add_flag(name, value)
      @flags[name.to_sym] = value
    end

    def flag(name, default)
      @flags.fetch(name, default)
    end

    def add_response(status, schema, description)
      @responses[status] = {
          schema: schema,
          description: description
      }
    end

    def add_path(method, path)
      @paths.push(method: method, path: path)
    end

    def finalize!(class_name, method_name)
      @responses.each do |code, response|
        name = Types::Namespace.with_namespace(
            Types::Namespace.fetch(@source_file),
            "#{RailsHelper.clean_controller_name(class_name)}.#{method_name.to_s.camelcase}.#{Rack::Utils::SYMBOL_TO_STATUS_CODE.key(code).to_s.camelize}Response".to_sym
        )
        AnnotationTypes::CustomT.register(name, response[:schema])

        response.merge!(schema: AnnotationTypes::CustomT.new(name))
      end
    end

    def to_schema
      @params.map { |k, v| [k, v[:schema]] }.to_h
    end
  end

end
