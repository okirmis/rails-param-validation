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
          class_name = self.name.gsub(/Controller$/, '').downcase.to_sym
          method_name = name.to_sym

          @param_definition.store_origin! class_name, method_name
          @param_definition.finalize! class_name, method_name

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
      def param_definition
        @param_definition ||= ActionDefinition.new
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
        param_definition.description = description
      end

      def no_params
        param_definition
      end

      def accept_all_params
        param_definition.disable_param_validation!
      end

      def response(status, name, schema, description)
        param_definition.add_response status, name, schema, description
      end

      # @param [Hash] options to configure the route.
      def route(options)
        [:get, :put, :post, :patch].each do |method|
          paths = options.fetch(method, [])
          paths = [paths] unless paths.is_a? Array

          paths.each { |path| param_definition.add_path method, path }
        end

        if options.key? :params
          if options[:params] === :all
            accept_all_params
          elsif options[:params] === :none
            no_params
          else
            raise ArgumentError.new(":params option requires one of the following values: :all, :none")
          end
        end

        yield if block_given?
      end
    end
  end
end