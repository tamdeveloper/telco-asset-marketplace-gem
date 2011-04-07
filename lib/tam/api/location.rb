require 'json'
require 'tam/user'

# SMS part of the telco asset marketplace REST API
module TAM
  class API
    # Find the location (coordinates) of a user
    #
    # @return [Hash] 
    #   {"body"=>
    #    {"latitude"=>51.618,
    #     "timestamp"=>1302185772456,
    #     "accuracy"=>100,
    #     "longitude"=>23.9063},
    #   "status"=>{"code"=>0, "message"=>"Request was handled succesfully"}}
    def self.getcoord(user)
      response = dispatch_to_tam(:get, '/api/1/location/getcoord', user)
      JSON.parse response
    end
  end
end
