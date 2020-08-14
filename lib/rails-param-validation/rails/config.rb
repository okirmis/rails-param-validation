module RailsParamValidation

  class OpenApiMetaConfig
    attr_accessor :title, :version, :url, :description, :file_path, :security_schemes, :skip_format_endpoints

    def initialize
      app_class = Rails.application.class

      self.url = 'http://localhost:3000'
      self.title = app_name(app_class)
      self.version = '1.0'
      self.description = "#{app_name(app_class)} application"
      self.file_path = Rails.root.join("openapi.yaml").to_s
      self.security_schemes = {}
      self.skip_format_endpoints = true
    end

    private

    def app_name(klass)
      return klass.module_parent_name if klass.respond_to? :module_parent_name
      klass.parent.name
    end
  end

  class Configuration
    attr_accessor :use_default_json_response
    attr_accessor :use_default_html_response
    attr_accessor :use_validator_caching
    attr_accessor :raise_on_missing_annotation
    attr_accessor :default_body_content_type
    attr_accessor :default_action_flags
    attr_accessor :post_action_definition_hook
    attr_accessor :auto_include_in_classes
    attr_reader   :openapi

    def initialize
      @use_default_json_response = true
      @use_default_html_response = true
      @use_validator_caching = Rails.env.production?
      @raise_on_missing_annotation = true
      @default_body_content_type = 'application/json'
      @default_action_flags = {}
      @post_action_definition_hook = ->(_action_definition) {}
      @auto_include_in_classes = %w[ActionController::Base ActionController::API]
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.openapi
    @openapi ||= OpenApiMetaConfig.new
  end

end
