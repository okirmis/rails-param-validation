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
        parameters[param.to_s] = to_hash_type value
      end

      validator = RailsParamValidation::ValidatorFactory.create definition.to_schema

      result = validator.matches?([], parameters)

      if result.matches?
        # Copy the parameters if the validation succeeded
        @validated_parameters = result.value
      else
        # Render an appropriate error message
        render json: {
            status: :fail,
            errors: result.errors.map { |e| "#{e[:path].join('/')}: #{e[:message]}" }
        }, status: 400
      end
    end

    def params
      @validated_parameters || super
    end

    # Convert params to "normal" types
    def to_hash_type(params)
      case params.class
      when Array
        params.map(&method(:to_hash_type))
      when ActionController::Parameters
        params.keys.map { |k| [k, to_hash_type(params[k])] }.to_h
      else
        params
      end
    end
  end
end

