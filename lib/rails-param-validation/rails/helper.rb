module RailsParamValidation

  class RailsHelper
    def self.controller_to_tag(klass)
      (klass.is_a?(String) ? klass : klass.name).gsub(/Controller$/, '').to_sym
    end

    def self.clean_controller_name(klass)
      klass = klass.to_s if klass.is_a? Symbol
      (klass.is_a?(String) ? klass : klass.name).gsub(/Controller$/, '').split('::').map { |p| p.capitalize }.join.to_sym
    end
  end

end