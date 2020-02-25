require 'uri'

require_relative './routing_helper'

module RailsParamValidation

  class OpenApi
    OPENAPI_VERSION = "3.0.0"

    def initialize(title, version, url, description)
      @info = {
          title: title, version: version,
          description: description,
          url: [url], basePath: URI(url).path
      }

      @actions = []

      load_from_annotations
    end

    def to_object
      object = {
        openapi: OPENAPI_VERSION,
        info: { version: @info[:version], title: @info[:title], description: @info[:description] },
        servers: @info[:url].map { |url| { url: url } },
        paths: {},
        components: { schemas: {} }
      }

      @actions.each do |operation|
        body = operation.params.filter { |_, v| v[:type] == :body }.map { |name, pd| [name, pd[:schema]] }.to_h

        parameters = operation.params.filter { |_, v| v[:type] != :body }.map do |name, pd|
          param_definition = { name: name, in: pd[:type] }
          if pd[:description].present?
            param_definition[:description] = pd[:description]
          end

          validator = RailsParamValidation::ValidatorFactory.create pd[:schema]
          param_definition[:required] = true unless validator.is_a? RailsParamValidation::OptionalValidator
          param_definition[:schema] = validator.to_openapi

          param_definition
        end

        RoutingHelper.routes_for(operation.controller.to_s, operation.action.to_s).each do |route|
          action_definition = {
              operationId: "#{route[:method].downcase}#{route[:path].split(/[^a-zA-Z0-9]+/).map(&:downcase).map(&:capitalize).join}",
              summary: operation.description,
              tags: [operation.controller],
              parameters: parameters,
              responses: operation.responses.map do |status, values|
                [
                    status.to_s,
                    {
                        description: values[:description],
                        content: {
                            operation.request_body_type => {
                                schema: ValidatorFactory.create(values[:schema]).to_openapi
                            }
                        }
                    }
                ]
              end.to_h
          }

          if body.any?
            body_type_name = "#{operation.controller.capitalize}#{operation.action.capitalize}Body".to_sym
            AnnotationTypes::CustomT.register(body_type_name, body)

            action_definition[:requestBody] = {
                content: {
                    operation.request_body_type => {
                        schema: ValidatorFactory.create(AnnotationTypes::CustomT.new(body_type_name)).to_openapi
                    }
                }
            }
          end

          object[:paths][route[:path]] ||= {}
          object[:paths][route[:path]][route[:method].downcase.to_sym] = action_definition
        end
      end

      AnnotationTypes::CustomT.types.each do |name|
        object[:components][:schemas][name] = ValidatorFactory.create(AnnotationTypes::CustomT.registered(name)).to_openapi
      end

      stringify_values object
    end

    protected

    def load_from_annotations
      AnnotationManager.instance.classes.each do |klass|
        AnnotationManager.instance.methods(klass).each do |method|
          params = AnnotationManager.instance.method_annotation klass, method, :param_definition
          next if params.nil?

          @actions.push params
        end
      end
    end

    def stringify_values(object)
      if object.is_a? Hash
        return object.map { |k, v| [stringify_values(k), stringify_values(v)] }.to_h
      elsif object.is_a? Array
        return object.map { |k| stringify_values k }
      elsif object.is_a? Symbol
        return object.to_s
      else
        return object
      end
    end
  end

end
