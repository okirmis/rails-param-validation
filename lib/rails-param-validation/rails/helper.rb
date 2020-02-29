module RailsParamValidation

  class RailsHelper
    def self.controller_to_tag(klass)
      (klass.is_a?(String) ? klass : klass.name).gsub(/Controller$/, '').to_sym
    end
  end

end