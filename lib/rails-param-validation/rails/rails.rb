require_relative './validation_extension'
require_relative './annotation_extension'
require_relative './param_validation_failed_error'

module RailsParamValidation
  class Railtie < Rails::Railtie
    initializer 'rails_param_validation.action_controller_extension' do
      ActionController::Base.send :include, ActionControllerExtension
      ActionController::Base.send :include, AnnotationExtension
      ActionController::Base.send :extend, RailsParamValidation::Types
    end
  end
end

