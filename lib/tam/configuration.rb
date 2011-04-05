module TAM
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {TAM::API}
    VALID_OPTIONS_KEYS = [
      :consumer_key,
      :consumer_secret,
      :consumer_handler,
      :site,
      :request_token_path,
      :access_token_path,
      :authorize_path,
      :oauth_scheme,
      :oauth_http_method].freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS
      
    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end
    
    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end
    
    # Create a hash of options and their values
    def options
      Hash[VALID_OPTIONS_KEYS.map {|key| [key, send(key)] }]
    end

    # Reset all configuration options to defaults
    def reset
      self.consumer_key       = nil
      self.consumer_secret    = nil
      self.consumer_handler   = nil
      self.site               = 'https://telcoassetmarketplace.com'
      self.request_token_path = '/api/1/oauth/request_token'
      self.access_token_path  = '/api/1/oauth/access_token'
      self.authorize_path     = '/web/authorize'
      self.oauth_scheme       = :query_string
      self.oauth_http_method  = :get
      self
    end
  end  
end
    