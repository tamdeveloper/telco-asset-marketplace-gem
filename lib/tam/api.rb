require 'sinatra'
require 'tam/error'

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
    
    def dispatch(method, *args)
      if !TAM.consumer_handler.nil? and TAM.consumer_handler.respond_to?(method)
        TAM.consumer_handler.send(method, *args)
        response.status = 200
      elsif
        response.status = 500
        'Application has not configured the telco asset marketplace consumer_handler'
      end
    end
    
    def self.create_oauth_consumer
      if TAM.consumer_key.nil? or TAM.consumer_secret.nil?
        raise OAuthConsumerAttributesMissing.new
      end
      
      OAuth::Consumer.new(TAM.consumer_key, TAM.consumer_secret,
        {
          TAM.site,
          TAM.request_token_path,
          TAM.access_token_path,  
          TAM.authorize_path, 
          TAM.oauth_scheme,
          TAM.oauth_http_method
        })
    end
    
  end
end
