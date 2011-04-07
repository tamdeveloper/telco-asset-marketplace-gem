require 'json'
require 'tam/user'

# SMS part of the telco asset marketplace REST API
module TAM
  class API
    # Find the location (coordinates) of a user
    def self.getcoord(user)
      response = dispatch_to_tam(:get, '/api/1/location/getcoord', user)
      JSON.parse response
    end
  end
end
