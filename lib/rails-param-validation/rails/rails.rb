require_relative './extensions/validation_extension'
require_relative './extensions/annotation_extension'
require_relative './extensions/custom_type_extension'

require_relative './openapi/openapi'

require_relative '../errors/param_validation_failed_error'
require_relative '../errors/missing_parameter_annotation'
require_relative '../errors/type_not_found'

require_relative './config'
require_relative './helper'

module RailsParamValidation
  class Railtie < Rails::Railtie
    railtie_name :param_validation

    initializer 'rails_param_validation.action_controller_extension' do
      ActiveSupport.on_load(:action_controller) do
        RailsParamValidation.config.auto_include_in_classes.each do |klass_name|
          klass = klass_name.constantize

          klass.send :include, ActionControllerExtension
          klass.send :include, AnnotationExtension
          klass.send :include, CustomTypesExtension
          klass.send :extend, RailsParamValidation::Types
        end
      end
    end

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end

