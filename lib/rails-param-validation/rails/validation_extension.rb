module RailsParamValidation
  module ActionControllerExtension
    def self.included(klass)
      klass.send(:before_action, :auto_validate_params!)
    end

    # The before_action function called which does the actual work
    def auto_validate_params!
      # @type [ActionDefinition] definition
      definition = RailsParamValidation::AnnotationManager.instance.annotation self.class.name, action_name.to_sym, :param_definition
      return if definition.nil?

      parameters = {}
      params.each do |param, value|
        # The params array contains the name and the controller, so we need to remove it
        if param == 'action' || param == 'controller'
          next
        end

        # Convert ActionController::Parameters to a normal hash
        parameters[param.to_s] = _to_hash_type value
      end

      validator = RailsParamValidation::ValidatorFactory.create definition.to_schema
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
          # Raise an exception which can be handled using rescue_from
          raise ParamValidationFailedError.new(result)
        end
        format.json do
          # Render a bad request result describing the errors
          render json: { status: :fail, errors: result.error_messages }, status: :bad_request
        end
      end
    end

    # Convert params to "normal" types
    def _to_hash_type(params)
      return params.map(&method(:_to_hash_type)) if params.is_a?(Array)
      return params.keys.map { |k| [k, _to_hash_type(params[k])] }.to_h if params.is_a?(ActionController::Parameters)

      params
    end
  end
end

