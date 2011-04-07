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
      :oauth_http_method,
      :callback_path].freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS
      
    def consumer_handler=(consumer_handler)
      if consumer_handler.class == String
        begin
          @consumer_handler = Object.const_get(consumer_handler).new
        rescue NameError => error
          LOGGER.error 'Application has provided an invalid telco asset marketplace consumer_handler: ' + TAM.consumer_handler
          raise InvalidConsumerHandler.new 'Application has provided an invalid telco asset marketplace consumer_handler: ' + TAM.consumer_handler
        end
      else
        @consumer_handler = consumer_handler
      end
    end
    
    def consumer_handler
      @consumer_handler
    end
    
    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end
    
    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end
    
    def configure(config)
      unless config.empty?
        self.consumer_key       = config['consumer_key']        if config['consumer_key']
        self.consumer_secret    = config['consumer_secret']     if config['consumer_secret']
        self.consumer_handler   = config['consumer_handler']    if config['consumer_handler']
        self.site               = config['site']                if config['site']
        self.request_token_path = config['request_token_path']  if config['request_token_path']
        self.access_token_path  = config['access_token_path']   if config['access_token_path']
        self.authorize_path     = config['authorize_path']      if config['authorize_path']
        self.oauth_scheme       = config['oauth_scheme']        if config['oauth_scheme']
        self.oauth_http_method  = config['oauth_http_method']   if config['oauth_http_method']
        self.callback_path      = config['callback_path']       if config['callback_path']
      end
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
      self.callback_path      = 'tamapi'
      self
    end
  end  
end
    