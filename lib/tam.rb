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

  private
  
  # Attempts to load the telco asset marketplace configuration from config/tam.yml
  # in a rails 3 application.
  # Besides using a tam.yml, developers can also configure directly TAM settings, e.g.:
  # TAM.consumer_key = 'h42woy35tl08o44l'
  def self.config
    config = load_config(File.join('config', 'tam.yml')).freeze
    configure(config)
  end
  
  def self.load_config(yaml_file)
    return {} unless File.exist?(yaml_file)
    cfg = YAML::load(File.open(yaml_file))
    if defined? Rails
      cfg = cfg[Rails.env]
    end
    cfg
  end
  
  self.config
end
