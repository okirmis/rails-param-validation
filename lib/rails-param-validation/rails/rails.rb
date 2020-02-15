require_relative './extensions/validation_extension'
require_relative './extensions/annotation_extension'
require_relative '../errors/param_validation_failed_error'
require_relative './config'

module RailsParamValidation
  class Railtie < Rails::Railtie
    initializer 'rails_param_validation.action_controller_extension' do
      ActionController::Base.send :include, ActionControllerExtension
      ActionController::Base.send :include, AnnotationExtension
      ActionController::Base.send :extend, RailsParamValidation::Types
    end
  end
end

