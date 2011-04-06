require 'sinatra'
require 'oauth'
require 'json'
require 'tam/user'

# SMS part of the telco asset marketplace REST API
module TAM
  class API
    # URL handler for receiving SMS
    # @private
    post "/*/receive_sms" do
      request.body.rewind # in case someone already read it
      
      data = JSON.parse request.body.read

      access_token = data["access_token"]
      token_secret = data["token_secret"]
      from_user = User.new(access_token, token_secret)
      to_app = data["to"]
      body = data["body"]
      
      dispatch_to_handler('receive_sms', from_user, to_app, body)
    end
    
    # Sends an SMS
    def self.send_sms(from_app, to_user, body)
      payload = JSON.generate({'body' => body, 'from' => from_app})
      dispatch_to_tam('/api/1/sms/send', to_user, payload)
    end
  end
end
