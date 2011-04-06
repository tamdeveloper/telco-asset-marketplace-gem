require 'sinatra'
require 'oauth'
require 'tam/error'
require 'tam/user'

# OAUTH part of the telco asset marketplace REST API
module TAM
  class API
    enable :sessions
    
    # Authorizes a user of telco asset marketplace to use your application
    #
    # @return [TAM::User]
    def self.authorize
      consumer = create_oauth_consumer
      request_token = consumer.get_request_token
      session[:request_token] = request_token
      puts session[:request_token]
      
      redirect request_token.authorize_url(:oauth_callback => url('/tamapi/oauth_callback'))
    end
    
    # OAUTH callback for telco asset marketplace
    get '/*/oauth_callback' do
      puts 'back to callback'
      puts session[:request_token]
      puts params[:denied]
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