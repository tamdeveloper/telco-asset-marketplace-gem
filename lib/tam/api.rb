require 'sinatra'

module TAM
  class API < Sinatra::Base
    require 'tam/api/sms'
    
    def dispatch(method, *args)
      if !TAM.consumer_handler.nil? and TAM.consumer_handler.respond_to?(method)
        TAM.consumer_handler.send(method, *args)
        response.status = 200
      elsif
        response.status = 500
        'Application has not configured the telco asset marketplace consumer_handler'
      end
    end
    
  end
end
