require 'tam/railtie' if defined? ::Rails::Railtie
require 'tam/configuration'
require 'tam/api'

module TAM
  extend Configuration

  # If in rails environment then we use the rails default logger
  # otherwise we create one that points to the standard output
  LOGGER = 
    if defined? Rails 
      RAILS_DEFAULT_LOGGER
    else 
      Logger.new(STDOUT)
    end

end
