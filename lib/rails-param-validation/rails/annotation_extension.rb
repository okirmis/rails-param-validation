require_relative './action_definition'
require_relative './annotation_manager'

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
          AnnotationManager.instance.annotate! self, name, :param_definition, @param_definition
          @param_definition = nil

          # Parameter wrapping needs to be disabled
          wrap_parameters false
        end

        # If there already was an existing method_added implementation, call it
        existing_method_added&.call(name)
      end
    end

    module ClassMethods
      # @param [Symbol] name Name of the parameter as it is accessible by params[<name>]
      # @param schema Definition of the schema (according to the available validators)
      # @param [String] description Description of the param, just for documentation
      def param(name, schema, description = nil)
        @param_definition ||= ActionDefinition.new
        @param_definition.add_param name, schema, description
      end
    end
  end
end