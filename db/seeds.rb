# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Message.create(
  client: 'WM',
  message_id: 'RCV0001',
  message_description: 'Location #{message_param[0]} not found'
)

Message.create(
  client: 'WM',
  message_id: 'RCV0002',
  message_description: 'Location #{message_id} is not valid receiving location'
)  

Message.create(
  client: 'WM',
  message_id: 'RCV0003',
  message_description: 'Dock Door occupied by another shipment'
)

Message.create(
  client: 'WM',
  message_id: 'RCV0004',
  message_description: 'Shipment #{message_param[0]} not found'
)
  
Message.create(
  client: 'WM',
  message_id: 'RCV0005',
  message_description: 'Shipment #{message_param[0]} not assigned to this Dock Door'
)

Message.create(
  client: 'WM',
  message_id: 'RCV0006',
  message_description: 'Shipment #{message_param[0]} not initiated'
)

Message.create(
  client: 'WM',
  message_id: 'RCV0007',
  message_description: 'Enter Case'
)
  
Message.create(
  client: 'WM',
  message_id: 'RCV0008',
  message_description: 'Case #{message_param[0]} already exists'
)

Message.create(
  client: 'WM',
  message_id: 'RCV0009',
  message_description: 'Case #{message_param[0]} does not exist'
)

Message.create(
  client: 'WM',
  message_id: 'RCV0010',
  message_description: 'Case #{message_param[0]} already received'
)
  
Message.create(
  client: 'WM',
  message_id: 'RCV0011',
  message_description: 'Item #{message_param[0]} does not exist in Itemmaster'
)

Message.create(
  client: 'WM',
  message_id: 'RCV0012',
  message_description: 'Item #{message_param[0]} not found in this shipment'
)
 
Message.create(
  client: 'WM',
  message_id: 'RCV0013',
  message_description: 'Item #{message_param[0]} is not associated to this Case'
)
  
Message.create(
  client: 'WM',
  message_id: 'RCV0014',
  message_description: 'Quantity entered does not match with the qty on the case'
)
  
Message.create(
  client: 'WM',
  message_id: 'RCV0015',
  message_description: 'Quantity received exceeds shipped quantity'
)
