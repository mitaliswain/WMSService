class GlobalConfiguration < ActiveRecord::Base
  
  def self.get_configuration(condition)
    
     configuration_hash = {}
     self.where(condition).where(enable: true).each do |configuration|
       
       configuration_hash.store(configuration.key, configuration.value)
       
     end
     return OpenStruct.new(configuration_hash.symbolize_keys)
     
   rescue
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


end
