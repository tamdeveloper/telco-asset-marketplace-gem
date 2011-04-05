require 'tam/configuration'
require 'tam/api'

module TAM
  extend Configuration
  
  def self.hello
    puts "Hello world"
  end
  
  class AnApp < Sinatra::Base
    get "/sinatra" do
      "Hello from Sinatra's world!!"
    end
  end
  
end