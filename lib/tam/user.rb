module TAM
  # Represents an end-user of telco asset marketplace (a subscriber)
  class User
    attr_accessor :access_token
    attr_accessor :token_secret
    
    def initialize(access_token, token_secret)
      :access_token = access_token
      :token_secret = token_secret
    end
  end
end