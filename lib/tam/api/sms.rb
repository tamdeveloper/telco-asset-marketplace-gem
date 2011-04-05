module TAM
  class API
    # URL handler for receiving SMS
    post "/*/receive_sms" do
      request.body.rewind # in case someone already read it
      
      data = JSON.parse request.body.read
      sms_body = data["body"]
      access_token = data["access_token"]
      
      dispatch('receive_sms', access_token, sms_body)
    end
    
  end
end
