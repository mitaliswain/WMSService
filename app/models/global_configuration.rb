class GlobalConfiguration < ActiveRecord::Base
  
  def initialize option_data={}
    super
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
       config_set =  ConfigSet.new(configuration_hash.symbolize_keys)
       config_set.config_object, config_set.old_config_set = self , config_set.clone
       config_set
     end
  end
  


  def set update_hash
    
    update_hash.each do |up_key, up_value| 
          self.class.where(option).where(key: up_key.to_s).where(enable: true).each do |configuration|
          configuration.update_attributes(value: up_value) 
      end   
    end
  end


end

class ConfigSet < OpenStruct

  attr_accessor :config_object, :old_config_set   
  
  def set
    config_object.set hash_diff(self.marshal_dump , old_config_set.marshal_dump)
  end
  
  def hash_diff (from_hash , to_hash)
    diff_hash = {}
    from_hash.each do |key, val|
      diff_hash[key] = val unless (to_hash[key] && to_hash[key] == val)
    end
    diff_hash
    
  end
 
end  