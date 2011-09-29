require 'spec_helper'
require 'tam/api'
require 'tam/user'
require 'rack/test'
require 'json'
require 'webmock/rspec'

describe TAM::API, "when sending sms" do
  include WebMock::API
  include OAuthSettings
  
  it "should succelfully send the request to platform" do
    #given
    TAM.expects(:consumer_key).twice().returns(ConsumerKey)
    TAM.expects(:consumer_secret).twice().returns(ConsumerSecret)
    TAM.expects(:site).returns(Site)
    TAM.expects(:request_token_path).returns('/api/1/oauth/request_token')
    TAM.expects(:access_token_path).returns('/api/1/oauth/access_token')
    TAM.expects(:authorize_path).returns('/web/authorize')
    TAM.expects(:oauth_scheme).returns(:query_string)
    TAM.expects(:oauth_http_method).returns(:get)
    http_stub = stub_request(:post, /.*\/api\/1\/sms\/send.*/).with { |request|  assert_request(request, { :query => OAuthParams, :body => "{\"body\":\"test message\",\"from\":\"to_app\"}"})}.to_return(:body => load_fixture("tam_send_sms_success.json"))
                  
    #when
    body = TAM::API.send_sms("to_app", TAM::User.new(AccessToken,  AccessSecret), 'test message')
    
    #then
    http_stub.should have_been_requested.times(1)
    body["status"]["code"].should == 0
    body["status"]["message"].should == "Message sent successfully"
  end
  
  it "sends sms request with transaction id to platform" do
    #given
    TAM.expects(:consumer_key).twice().returns(ConsumerKey)
    TAM.expects(:consumer_secret).twice().returns(ConsumerSecret)
    TAM.expects(:site).returns(Site)
    TAM.expects(:request_token_path).returns('/api/1/oauth/request_token')
    TAM.expects(:access_token_path).returns('/api/1/oauth/access_token')
    TAM.expects(:authorize_path).returns('/web/authorize')
    TAM.expects(:oauth_scheme).returns(:query_string)
    TAM.expects(:oauth_http_method).returns(:get)
    http_stub = stub_request(:post, /.*\/api\/1\/sms\/send.*/).with { |request| assert_request(request, { :query => OAuthParams, :body => "{\"body\":\"test message\",\"from\":\"to_app\",\"transaction_id\":\"tran_id\"}"})}.to_return(:body => load_fixture("tam_send_sms_success.json"))
                  
    #when
    body = TAM::API.send_sms("to_app", TAM::User.new(AccessToken,  AccessSecret), 'test message', 'tran_id')
    
    #then
    http_stub.should have_been_requested.times(1)
    body["status"]["code"].should == 0
    body["status"]["message"].should == "Message sent successfully"
  end
  
  def load_fixture(fixture)
    IO.read("spec/fixtures/#{fixture}")
  end
  
  def assert_request(req, matchers)
    return (assert_query(req.uri, matchers[:query]) and req.body == matchers[:body])
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