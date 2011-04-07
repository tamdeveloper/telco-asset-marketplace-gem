require 'sinatra'
require 'oauth'
require 'tam/error'
require 'tam/user'

# OAUTH part of the telco asset marketplace REST API
module TAM
  class API
    enable :sessions
    
    # Authorizes a user of telco asset marketplace to use your application
    # After the OAUTH flow is finished then the configured consumer_handler.authorized(user)
    # or consumer_handler.denied are invoked
    get '/*/authorize' do
      consumer = TAM::API.create_oauth_consumer
      request_token = consumer.get_request_token
      session[:request_token] = request_token
      
      redirect request_token.authorize_url(:oauth_callback => url('/tamapi/oauth_callback'))
    end
    
    # OAUTH callback for telco asset marketplace
    # @private
    get '/*/oauth_callback' do
      if params[:denied].nil?
        consumer = TAM::API.create_oauth_consumer
        request_token = session[:request_token]
        verifier = params[:oauth_verifier]
        access_token = request_token.get_access_token(:oauth_verifier => verifier)
        user = User.new(access_token.token, access_token.secret)
        redirect dispatch_to_handler('authorized', user)
      else
        redirect dispatch_to_handler('denied')
      end
    end
    
    private
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