module RailsParamValidation
  module ActionControllerExtension
    def self.included(klass)
      klass.send(:before_action, :auto_validate_params!)
    end

    # The before_action function called which does the actual work
    def auto_validate_params!
      # @type [ActionDefinition] definition
      definition = RailsParamValidation::AnnotationManager.instance.method_annotation self.class.name, action_name.to_sym, :param_definition

      if definition.nil?
        if RailsParamValidation.config.raise_on_missing_annotation
          raise RailsParamValidation::MissingParameterAnnotation.new
        else
          return
        end
      end

      return unless definition.param_validation?

      parameters = {}
      params.each do |param, value|
        # The params array contains the name and the controller, so we need to remove it
        if param == 'action' || param == 'controller'
          next
        end

        # Convert ActionController::Parameters to a normal hash
        parameters[param.to_s] = _to_hash_type value
      end

      action = params['action']
      controller = params['controller']

      validator = _validator_from_schema controller, action, definition.to_schema
      result = validator.matches?([], parameters)

      if result.matches?
        # Copy the parameters if the validation succeeded
        @validated_parameters = result.value
      else
        # Render an appropriate error message
        _render_invalid_param_response result
      end
    end

    def params
      @validated_parameters || super
    end

    def _render_invalid_param_response(result)
      # Depending on the accept header, choose the way to answer
      respond_to do |format|
        format.html do
          if RailsParamValidation.config.use_default_html_response
            _create_html_error result
          else
            raise ParamValidationFailedError.new(result)
          end
        end
        format.json do
          if RailsParamValidation.config.use_default_json_response
            _create_json_error result
          else
            raise ParamValidationFailedError.new(result)
          end
        end
      end
    end

    # Create an empty object as JSON response
    def _create_json_error(result)
      render json: { status: :fail, errors: result.error_messages }, status: :bad_request
    end

    # Create an empty html error page
    def _create_html_error(result)
      @@_param_html_error_template ||= File.read(File.dirname(__FILE__) + '/error.template.html.erb')
      render html: ERB.new(@@_param_html_error_template).result(binding).html_safe, status: :bad_request
    end

    # Convert params to "normal" types
    def _to_hash_type(params)
      return params.map(&method(:_to_hash_type)) if params.is_a?(Array)
      return params.keys.map { |k| [k, _to_hash_type(params[k])] }.to_h if params.is_a?(ActionController::Parameters)

      params
    end

    # @return [Validator]
    def _validator_from_schema(controller, method, schema)
      unless RailsParamValidation.config.use_validator_caching
        return RailsParamValidation::ValidatorFactory.create schema
      end

      # Setup static key if it doesn't already exist
      @@cache ||= {}

      # Create and/or return validator
      @@cache["#{controller}##{method}"] ||= RailsParamValidation::ValidatorFactory.create schema
    end
  end
end

