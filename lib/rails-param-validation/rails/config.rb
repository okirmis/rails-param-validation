module RailsParamValidation

  class OpenApiMetaConfig
    attr_accessor :title, :version, :url, :description

    def initialize
      self.url = 'http://localhost:3000'
      self.title = Rails.application.class.module_parent_name
      self.version = '1.0'
      self.description = "#{Rails.application.class.module_parent_name} application"
    end
  end

  class Configuration
    attr_accessor :use_default_json_response
    attr_accessor :use_default_html_response
    attr_accessor :use_validator_caching
    attr_accessor :raise_on_missing_annotation
    attr_accessor :default_body_content_type
    attr_reader   :openapi

    def initialize
      @use_default_json_response = true
      @use_default_html_response = true
      @use_validator_caching = Rails.env.production?
      @raise_on_missing_annotation = true
      @default_body_content_type = 'application/json'
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.openapi
    @openapi ||= OpenApiMetaConfig.new
  end

end
