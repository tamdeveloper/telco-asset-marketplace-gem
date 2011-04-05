module TAM
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {TAM::API}
    VALID_OPTIONS_KEYS = [
      :consumer_key,
      :consumer_secret].freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS
      
    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end
    
    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end
    
    # Create a hash of options and their values
    def options
      Hash[VALID_OPTIONS_KEYS.map {|key| [key, send(key)] }]
    end

    # Reset all configuration options to defaults
    def reset
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self
    end
  end  
end
    