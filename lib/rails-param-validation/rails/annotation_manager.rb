module RailsParamValidation

  class AnnotationManager
    attr_reader :annotations
    def initialize
      @annotations = {}
    end

    def self.instance
      @instance ||= AnnotationManager.new
    end

    def classes
      @annotations.keys
    end

    def methods(klass)
      @annotations.fetch(klass, {}).keys
    end

    def annotate_method!(klass, method_name, type, value)
      @annotations[klass.name] ||= {}
      @annotations[klass.name][method_name] ||= {}
      @annotations[klass.name][method_name][type] = value
    end

    def method_annotation(class_name, method_name, type)
      @annotations.fetch(class_name, {}).fetch(method_name, {}).fetch(type, nil)
    end

    def annotate_class!(klass, type, value)
      annotate_method! klass, '', type, value
    end

    def class_annotation(class_name, type)
      method_annotation class_name, '', type
    end
  end

end
