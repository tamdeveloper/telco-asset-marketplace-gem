require 'sinatra'
require 'oauth'
require 'tam/error'
require 'tam/user'

module TAM
  # Wrapper for the telco asset marketplace REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {https://code.telcoassetmarketplace.com the telco asset marketplace API Documentation}.
  # @see http://code.telcoassetmarketplace.com
  class API < Sinatra::Base
    # Require api method modules after initializing the API class in
    # order to avoid a superclass mismatch error, allowing those modules to be
    # API-namespaced.
    require 'tam/api/oauth'
    require 'tam/api/sms'
    require 'tam/api/location'
    
    # Dispatches the request to the telco asset marketplace handler configured by 
    # this gem client
    def dispatch_to_handler(method, *args)
      if TAM.consumer_handler.nil?
        LOGGER.error 'Application has not configured the telco asset marketplace consumer_handler'
        raise InvalidConsumerHandler.new 'Application has not configured the telco asset marketplace consumer_handler'
      end
      
      if TAM.consumer_handler.respond_to?(method)
        begin
          return TAM.consumer_handler.send(method, *args)
        rescue TAM::Error => error
          LOGGER.error 'Application has suffered an internal error: ' + error.message + ', ' + error.body
          raise error
        end
      end
      
    end
    
    # Dispatches the request to the telco asset marketplace REST API
    def self.dispatch_to_tam(http_method, endpoint, user, payload='')
      consumer = create_oauth_consumer
      access_token = OAuth::AccessToken.new(consumer, user.access_token, user.token_secret)

      response = access_token.send(http_method, endpoint, payload, {'Content-Type' => 'application/json'})
      
      if response.class == Net::HTTPOK
        return response.body
      elsif response.class == Net::HTTPUnauthorized
        LOGGER.error 'Request not authorized ' + response.message + ', ' + response.body
        raise RequestNotAuthorized.new(response.message, response.body)
      elsif response.class == Net::HTTPBadRequest
        if response.body.include? 'consumer_key_unknown'
          LOGGER.error 'Configured telco asset marketplace consumer_key is not valid: ' + response.message + ', ' + response.body
          raise InvalidConsumerKey.new(response.message, response.body)
        elsif response.body.include? 'signature_invalid'
          LOGGER.error 'Configured telco asset marketplace consumer_secret is not valid: ' + response.message + ', ' + response.body
          raise InvalidConsumerSecret.new(response.message, response.body)
        else
          raise UnexpectedError.new(response.message, response.body)
        end
      else
        raise UnexpectedError.new(response.message, response.body)
      end
    end
    
  end
end
