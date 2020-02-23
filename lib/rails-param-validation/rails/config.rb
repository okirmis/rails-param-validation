module RailsParamValidation

  class Configuration
    attr_accessor :use_default_json_response
    attr_accessor :use_default_html_response
    attr_accessor :use_validator_caching
    attr_accessor :raise_on_missing_annotation
    attr_accessor :default_body_content_type

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

end
