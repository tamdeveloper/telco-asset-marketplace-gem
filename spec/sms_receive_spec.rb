require 'spec_helper'
require 'tam/api'
require 'tam/user'
require 'rack/test'
require 'mocha'
require 'json'

describe TAM::API, "when receiving sms" do
  include Rack::Test::Methods

  def app
    TAM::API
  end
  
  before(:all) do
    logger = stub('logger')
    logger.stubs(:error)
    TAM.const_set(:LOGGER, logger)
  end
  
  it "should pass request to tam sms handler and render success" do
    #given
    handler = stub('consumer_handler')
    handler.expects(:respond_to?).with('receive_sms').returns(true)
    handler.expects(:send).with('receive_sms', TAM::User.new('token', 'secret'), 'to_app', 'message', nil)
    TAM.expects(:consumer_handler).times(3).returns(handler)
    #when
    post '/tamapi/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user' ,'access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_ok
  end
  
  it "shpuld pass request with transaction to tam sms handler and render success" do
    #given
    handler = stub('consumer_handler')
    handler.expects(:respond_to?).with('receive_sms').returns(true)
    handler.expects(:send).with('receive_sms', TAM::User.new('token', 'secret'), 'to_app', 'message', 'tran_id')
    TAM.expects(:consumer_handler).times(3).returns(handler)
    #when
    post '/tamapi/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user','transaction_id' => 'tran_id','access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_ok
  end
  
  it "should pass request to tam sms handler and render error on unexpected error" do
    #given
    handler = stub('consumer_handler')
    handler.expects(:respond_to?).with('receive_sms').returns(true)
    handler.stubs(:send).raises(TAM::UnexpectedError.new("Cannot handle"))
    TAM.expects(:consumer_handler).times(3).returns(handler)
    #when
    post '/tamapi/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user','transaction_id' => 'tran_id','access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_server_error
    last_response.body.should == "Cannot handle"
  end
  
  it "should pass request to tam sms handler and render error on missing consumer_handler" do
    #given
    handler = stub('consumer_handler')
    TAM.expects(:consumer_handler).times(1).returns(nil)
    #when
    post '/tamapi/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user','transaction_id' => 'tran_id','access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_server_error
    last_response.body.should == "Application has not configured the telco asset marketplace consumer_handler"
  end
end