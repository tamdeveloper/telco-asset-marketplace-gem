require 'sinatra'
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
    require 'tam/api/sms'
    
    # Dispatches the request to the telco asset marketplace handler configured by 
    # this gem client
    def dispatch_to_handler(method, *args)
      if !TAM.consumer_handler.nil? and TAM.consumer_handler.respond_to?(method)
        begin
          TAM.consumer_handler.send(method, *args)
          response.status = 200
        rescue TAM::Error => error
          response.status = 500
          'Application has suffered an internal error ' + error.message + ', ' + error.body
        end
      elsif
        response.status = 500
        'Application has not configured the telco asset marketplace consumer_handler'
      end
    end
    
    # Dispatches the request to the telco asset marketplace REST API
    def self.dispatch_to_tam(endpoint, user, payload)
      consumer = create_oauth_consumer
      access_token = OAuth::AccessToken.new(consumer, user.access_token, user.token_secret)

      response = access_token.post(endpoint, payload, {'Content-Type' => 'application/json'})
      
      if response.class == Net::HTTPUnauthorized
        raise RequestNotAuthorized.new(response.message, response.body)
      elsif response.class == Net::HTTPOK
        return
      else
        raise UnexpectedError.new(response.message, response.body)
      end
    end
    
    def self.create_oauth_consumer
      if TAM.consumer_key.nil? or TAM.consumer_secret.nil?
        raise OAuthConsumerAttributesMissing.new
      end
      
      OAuth::Consumer.new(TAM.consumer_key, TAM.consumer_secret,
        {
          :site => TAM.site,
          :request_token_path => TAM.request_token_path,
          :access_token_path => TAM.access_token_path,  
          :authorize_path => TAM.authorize_path, 
          :scheme => TAM.oauth_scheme,
          :http_method => TAM.oauth_http_method
        })
    end
    
  end
end
