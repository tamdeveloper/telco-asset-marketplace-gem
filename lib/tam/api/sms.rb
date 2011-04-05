module TAM
  class API
    # URL handler for receiving SMS
    post "/*/receive_sms" do
      request.body.rewind # in case someone already read it
      
      data = JSON.parse request.body.read
      body = data["body"]
      access_token = data["access_token"]
      token_secret = data["token_secret"]
      
      dispatch('receive_sms', access_token, token_secret, body)
    end
    
    def self.send_sms(access_token, token_secret, body)
      consumer = create_oauth_consumer
    end
  end
end
