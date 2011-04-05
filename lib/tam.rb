require 'tam/configuration'
require 'tam/api'

module TAM
  extend Configuration
  
  def self.hello
    puts "Hello world"
  end
  
  def self.add_route
    ActionController::Routing::Routes.draw do 
      match "receive_message" => "api#receive_message"
    end
  end
end