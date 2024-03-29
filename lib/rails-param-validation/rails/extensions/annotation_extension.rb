require_relative './../action_definition'
require_relative './../annotation_manager'

module RailsParamValidation
  module AnnotationExtension

    def self.included(klass)
      klass.extend ClassMethods

      # Check if there already is a method_added implementation
      begin
        existing_method_added = klass.method(:method_added)
      rescue NameError => e
        existing_method_added = nil
      end

      klass.define_singleton_method(:method_added) do |name|
        # If there is a parameter definition: annotate this method and reset the carrier variable
        if @param_definition
          # Store where this annotation came from
          class_name = RailsHelper.controller_to_tag self
          method_name = name.to_sym

          @param_definition.store_origin! class_name, method_name
          RailsParamValidation.config.post_action_definition_hook.call(@param_definition)
          @param_definition.finalize! class_name, method_name, (@base_paths || {}).fetch(self.name, self.name.gsub(/Controller$/, "").underscore)

          AnnotationManager.instance.annotate_method! self, name, :param_definition, @param_definition
          @param_definition = nil

          # Parameter wrapping needs to be disabled
          wrap_parameters false if respond_to? :wrap_parameters
        end

        # If there already was an existing method_added implementation, call it
        existing_method_added&.call(name)
      end
    end

    module ClassMethods
      def base_path(path, include_module_name: true)
        if include_module_name
          path = "#{module_parent_name.underscore}/#{path}".gsub("//", "/")
        end

        @base_paths ||= {}
        @base_paths[self.name] = path
      end

      def param_definition
        @param_definition || raise(StandardError.new "Annotation must be part of an operation-block")
      end

      # @param [Symbol] name Name of the parameter as it is accessible by params[<name>]
      # @param schema Definition of the schema (according to the available validators)
      # @param [String] description Description of the param, just for documentation
      def param(name, schema, type = :query, description = nil)
        param_definition.add_param name, type, schema, description
      end

      def query_param(name, schema, description = nil)
        param name, schema, :query, description
      end

      def body_param(name, schema, description = nil)
        param name, schema, :body, description
      end

      def path_param(name, schema, description = nil)
        param name, schema, :path, description
      end

      def body_type(mime_type)
        param_definition.request_body_type! mime_type
      end

      def desc(description)
        if @param_definition
          param_definition.description = description
        else
          AnnotationManager.instance.annotate_class! self, :description, description
        end
      end

      def no_params
        param_definition
      end

      def accept_all_params
        param_definition.disable_param_validation!
      end

      def response(status, schema, description)
        param_definition.add_response status, schema, description
      end

      def flag(name, value, _comment = nil)
        @param_definition.add_flag name, value
      end

      def security_hint(security)
        @param_definition.add_security(security)
      end

      def action(description = nil, flags = RailsParamValidation.config.default_action_flags)
        if description.is_a?(Hash)
          method = description.keys.first.to_sym
          path = description.values.first
          description = ""
        else
          method = nil
          path = nil
        end

        @param_definition = ActionDefinition.new(Types::Namespace.caller_file)
        @param_definition.description = description
        flags.each { |name, value| @param_definition.add_flag name, value }

        if method
          @param_definition.add_path method, path
        end

        yield
      end
    end
  end
end
