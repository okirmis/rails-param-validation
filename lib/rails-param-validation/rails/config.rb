module RailsParamValidation

  class Configuration
    attr_accessor :use_default_json_response, :use_default_html_response
    attr_accessor :use_validator_caching

    def initialize
      @use_default_json_response = true
      @use_default_html_response = true
      @use_validator_caching = Rails.env.production?
    end
  end

  def self.config
    @config ||= Configuration.new
  end

end
