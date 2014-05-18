class GlobalConfiguration < ActiveRecord::Base
  
  def self.get_configuration(input)
    
     configuration_hash = {}
     self.where(input).where(enable: true).each do |configuration|
       
       configuration_hash.store(configuration.key, configuration.value)
       
     end
     return OpenStruct.new(configuration_hash.symbolize_keys)

  end

  def self.set_configuration(update, condition)
    
    self.where(condition).where(enable: true).each do|configuration|
      configuration.update_attributes(update) 
    end
          
  end


end
