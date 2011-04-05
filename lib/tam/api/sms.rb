require 'tam/error'
require 'tam/user'

module TAM
  class API
    # URL handler for receiving SMS
    post "/*/receive_sms" do
      request.body.rewind # in case someone already read it
      
      data = JSON.parse request.body.read
      body = data["body"]
      access_token = data["access_token"]
      token_secret = data["token_secret"]
      user = User.new(access_token, token_secret)
      
      dispatch('receive_sms', user, body)
    end
    
    def self.send_sms(user, body)
      consumer = create_oauth_consumer
      access_token = OAuth::AccessToken.new(consumer, user.access_token, user.token_secret)
      data = JSON.generate({'body' => body})
      response = access_token.post("/api/1/sms/send", data, {'Content-Type' => 'application/json'})
      
      if response.class == Net::HTTPUnauthorized
        raise RequestNotAuthorized.new(response.message, response.body)
      elsif response.class == Net::HTTPOK
        return
      else
        raise UnexpectedError.new(response.message, response.body)
      end
    end
  end
end
