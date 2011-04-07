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
    
    # Dispatches the request to the telco asset marketplace handler configured by 
    # this gem client
    def dispatch_to_handler(method, *args)
      if TAM.consumer_handler.nil?
        response.status = 500
        LOGGER.error 'Application has not configured the telco asset marketplace consumer_handler'
        return 'Application has not configured the telco asset marketplace consumer_handler'
      end
      
      if TAM.consumer_handler.class == String
        begin
          TAM.consumer_handler = Object.const_get(TAM.consumer_handler)
        rescue NameError => error
          response.status = 500
          LOGGER.error 'Application has provided an invalid telco asset marketplace consumer_handler: ' + TAM.consumer_handler
          return 'Application has provided an invalid telco asset marketplace consumer_handler: ' + TAM.consumer_handler
        end
      end
      
      if TAM.consumer_handler.respond_to?(method)
        begin
          TAM.consumer_handler.send(method, *args)
          response.status = 200
          return ''
        rescue TAM::Error => error
          response.status = 500
          LOGGER.error 'Application has suffered an internal error: ' + error.message + ', ' + error.body
          return 'Application has suffered an internal error: ' + error.message + ', ' + error.body
        end
      end
      
    end
    
    # Dispatches the request to the telco asset marketplace REST API
    def self.dispatch_to_tam(endpoint, user, payload)
      consumer = create_oauth_consumer
      access_token = OAuth::AccessToken.new(consumer, user.access_token, user.token_secret)

      response = access_token.post(endpoint, payload, {'Content-Type' => 'application/json'})
      
      if response.class == Net::HTTPOK
        return
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
