require 'rails'

module TAM
  class TamRailtie < Rails::Railtie
    initializer "tam.boot" do
      configure_with_yaml
    end
    
    private
    
    # Attempts to load the telco asset marketplace configuration from config/tam.yml
    # in a rails 3 application.
    # Besides using a tam.yml, developers can also configure directly TAM settings, e.g.:
    # TAM.consumer_key = 'h42woy35tl08o44l'
    def configure_with_yaml
      cfg = load_config(File.join(Rails.root, 'config', 'tam.yml')).freeze
      TAM.configure(cfg)
    end
    
    def load_config(yaml_file)
      return {} unless File.exist?(yaml_file)
      cfg = YAML::load(File.open(yaml_file))
      if defined? Rails
        cfg = cfg[Rails.env]
      end
      cfg
    end
    
  end
end