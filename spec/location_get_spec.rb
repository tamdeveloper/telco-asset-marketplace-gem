require 'spec_helper'
require 'tam/api'
require 'tam/user'
require 'rack/test'
require 'json'
require 'webmock/rspec'

describe TAM::API, "#getcoord" do
  include WebMock::API
  include OAuthSettings
  
  it "sends location request to platform" do
    #given
    TAM.expects(:consumer_key).twice().returns(ConsumerKey)
    TAM.expects(:consumer_secret).twice().returns(ConsumerSecret)
    TAM.expects(:site).returns(Site)
    TAM.expects(:request_token_path).returns('/api/1/oauth/request_token')
    TAM.expects(:access_token_path).returns('/api/1/oauth/access_token')
    TAM.expects(:authorize_path).returns('/web/authorize')
    TAM.expects(:oauth_scheme).returns(:query_string)
    TAM.expects(:oauth_http_method).returns(:get)
    http_stub = stub_request(:get, /.*\/api\/1\/location\/getcoord.*/).with { |request| assert_query(request.uri, OAuthParams) }.to_return(:body => load_fixture("tam_getcoord_success.json"))
                  
    #when
    body = TAM::API.getcoord(TAM::User.new(AccessToken, AccessSecret))
    
    #then
    http_stub.should have_been_requested.times(1)
    body["status"]["code"].should == 0
    body["status"]["message"].should == "Message sent successfully"
  end
    
  def load_fixture(fixture)
    IO.read("spec/fixtures/#{fixture}")
  end
  
  def assert_query(uri, params)
    uri_params = uri.query_values
    params.each do |key, value| 
      if not value.match(uri_params[key])
        return false
      end
    end
    return true
  end
end