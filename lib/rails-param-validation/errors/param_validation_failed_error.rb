module RailsParamValidation

  class ParamValidationFailedError < StandardError
    attr_reader :result

    def initialize(result)
      @result = result
      super "Parameter validation has failed: #{result.error_messages.join ", "}"
    end
  end

end
