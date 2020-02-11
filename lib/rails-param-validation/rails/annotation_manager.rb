module RailsParamValidation

  class AnnotationManager
    def initialize
      @annotations = {}
    end

    def self.instance
      @instance ||= AnnotationManager.new
    end

    def annotate!(klass, method_name, type, value)
      @annotations[klass.name] ||= {}
      @annotations[klass.name][method_name] ||= {}
      @annotations[klass.name][method_name][type] ||= value
    end

    def annotation(class_name, method_name, type)
      @annotations.fetch(class_name, {}).fetch(method_name, {}).fetch(type, nil)
    end
  end

end
