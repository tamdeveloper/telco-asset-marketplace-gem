require 'tam/configuration'
require 'tam/api'

module TAM
  extend Configuration

  private
  
  # Attempts to load the telco asset marketplace configuration from config/tam.yml
  # in a rails 3 application.
  # Besides using a tam.yml, developers can also configure directly TAM, e.g.:
  # TAM.consumer_key = 'h42woy35tl08o44l'
  def self.config
    puts 'Starting init'
    config = load_config(config_path).freeze
    pp config
    unless config.empty{}
      VALID_OPTIONS_KEYS.each do |key|
        self[key] = config[key]
      end
    end
    
    pp self
  end
  
  def self.config_path
    'config/database.yml'
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
