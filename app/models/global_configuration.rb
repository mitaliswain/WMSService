class GlobalConfiguration < ActiveRecord::Base
  
  
  def initialize option_data
    self.option = option_data
  end
  
  def self.get_configuration(condition)
    
    
     configuration_hash = {}
     self.where(condition).where(enable: true).each do |configuration|
    
       configuration_hash.store(configuration.key, configuration.value)
       
     end
     
     if configuration_hash.empty?
       raise raise ArgumentError, "Invalid Argument #{condition}"
     else
        return OpenStruct.new(configuration_hash.symbolize_keys)
     end
     
   rescue => er
     raise ArgumentError, "Invalid Argument #{condition}"
  end

  def self.set_configuration(update, condition)
    self.where(condition).where(enable: true).each do|configuration|
        configuration.update_attributes(update) 
    end
     
    self.get_configuration(condition)     
  
    rescue => ex
         raise ArgumentError, "Invalid Argument #{condition} or config value #{update}"  
  end

  def self.options option_data
    self.new option_data
  end  
  
  def options option_data
    self.option = option_data
    self
  end
  
  def option=(option_data)
      @option = @option ? @option.merge(option_data) : option_data if option_data    
  end
  
  def option
      @option
  end


  def get
    
     configuration_hash = {}
     self.class.where(option).where(enable: true).each do |configuration|   
       configuration_hash.store(configuration.key, configuration.value)   
     end
     
     if configuration_hash.empty?
       raise ArgumentError, "Invalid Argument #{self.option}"
     else
        return OpenStruct.new(configuration_hash.symbolize_keys)
     end
      
   rescue
     raise ArgumentError, "Invalid Argument #{self.option}"
  end

end
