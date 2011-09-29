require 'sinatra'
require 'oauth'
require 'json'
require 'tam/user'

# SMS part of the telco asset marketplace REST API
module TAM
  class API
    # URL handler for receiving SMS
    # After receiving an SMS, the configured 
    # consumer_handler.receive_sms(from_user, to_app, body)
    # is invoked
    #
    # @private
    post "/*/receive_sms" do
      request.body.rewind # in case someone already read it
      
      data = JSON.parse request.body.read

      access_token = data["access_token"]
      token_secret = data["token_secret"]
      from_user = User.new(access_token, token_secret)
      to_app = data["to"]
      body = data["body"]
      transaction_id = data["transaction_id"]

      begin
        dispatch_to_handler('receive_sms', from_user, to_app, body, transaction_id)
        response.status = 200
        return ''
      rescue Error => error
        response.status = 500
        return error.message
      end
    end
    
    # Sends an SMS
    def self.send_sms(from_app, to_user, body, transaction_id = nil)
      payload = {'body' => body, 'from' => from_app}
      if transaction_id
        payload["transaction_id"] = transaction_id
      end
      response = dispatch_to_tam(:post, '/api/1/sms/send', to_user, JSON.generate(payload))
      JSON.parse response
    end
  end
end
