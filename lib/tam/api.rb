require 'sinatra'
require 'json'

module TAM
  class API < Sinatra::Base
    
    # URL handler for receiving SMS
    post "/*/receive_sms" do
      request.body.rewind # incase someone already read it
      data = JSON.parse request.body.read
      puts data
      sms_body = data[:body]
      access_token = data[:access_token]
      
      dispatch('receive_sms', access_token, sms_body)
    end
    
    private
    def dispatch(method, *args)
      if !TAM.consumer_handler.nil? and TAM.consumer_handler.respond_to?(method)
        TAM.consumer_handler.send(method, *args)
        response.status = 200
      elsif
        response.status = 500
        'Application has not configured the telco asset marketplace consumer_handler'
      end
    end
    
  end
end
