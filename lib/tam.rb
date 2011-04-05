require 'tam/configuration'
require 'tam/api'

module TAM
  extend Configuration
  
  def self.hello
    puts "Hello world"
  end
end
