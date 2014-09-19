class Message < ActiveRecord::Base
  
  def self.get_message(client, message_id, message_param=[])
      template_message=self.where(client: client, message_id: message_id).first
      message = eval("\"" + template_message.message_description + "\"")  unless template_message.nil?
      message = "No message found for #{message_id}" if template_message.nil?
      message  
  end
  
end
