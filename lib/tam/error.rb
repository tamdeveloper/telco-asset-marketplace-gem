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

  # Raised when client performs a wrong OAUTH interaction (this is a super-class)
  class OAuthError < Error; end

  # Raised when client is using an invalid consumer_key
  class InvalidConsumerKey < OAuthError; end
  
  # Raised when client is using an invalid consumer_secret
  class InvalidConsumerSecret < OAuthError; end

  class UnexpectedError < Error; end  
end
  