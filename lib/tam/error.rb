module TAM
  # Custom error class for rescuing from all telco asset marketplace errors
  class Error < StandardError
    attr_reader :body

    def initialize(message, body = nil)
      @body = body
      super message
    end
  end
  
  # Raised when client tries to use any of the API methods that require OAUTH
  # without configuring the consumer_key or consumer_secret
  class OAuthConsumerAttributesMissing < Error
    def initialize
      super 'consumer_key or consumer_secret not configured'
    end
  end
  
  # Raised when client tries to use any of the API methods without user authorization
  class RequestNotAuthorized < Error; end  

  class UnexpectedError < Error; end  
end
  