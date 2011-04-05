module TAM
  # Custom error class for rescuing from all telco asset marketplace errors
  class Error < StandardError
    attr_reader :http_headers

    def initialize(message, http_headers)
      @http_headers = Hash[http_headers]
      super message
    end
  end
  
  # Raised when client tries to use any of the API methods that require OAUTH
  # without configuring the consumer_key or consumer_secret
  class OAuthConsumerAttributesMissing < Error; end
end
  