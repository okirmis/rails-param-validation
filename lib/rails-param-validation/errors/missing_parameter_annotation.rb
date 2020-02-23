module RailsParamValidation

  class MissingParameterAnnotation < StandardError
    def initialize
      super "Missing parameter annotation for controller action"
    end
  end

end