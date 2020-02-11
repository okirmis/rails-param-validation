require 'spec_helper'

module RailsParamValidation
  class ExampleWithoutMethodAdded
    include AnnotationExtension

    param :names, ArrayType(String)
    def sample_method
    end
  end

  class ExampleWithMethodAdded
    def self.original_method_added_calls
      @original_method_added
    end

    def self.method_added(name)
      (@original_method_added ||= []).push name
    end

    include AnnotationExtension

    param :names, ArrayType(String)
    def sample_method
    end
  end

  RSpec.describe AnnotationExtension do

    it "should store param definition annotations" do
      annotation = AnnotationManager.instance.annotation ExampleWithoutMethodAdded.name, :sample_method, :param_definition
      expect(annotation).to be_a(ActionDefinition)
    end

    it "should call original method_added implementations" do
      annotation = AnnotationManager.instance.annotation ExampleWithMethodAdded.name, :sample_method, :param_definition
      expect(annotation).to be_a(ActionDefinition)

      expect(ExampleWithMethodAdded.original_method_added_calls).to be_a Array
      expect(ExampleWithMethodAdded.original_method_added_calls).to eq([:sample_method])
    end

  end
end