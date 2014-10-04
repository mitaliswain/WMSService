# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

GlobalConfiguration.create({
  client:'WM', warehouse: 'WH1', sequence: 1, module: 'SHIPMENT', key: 'one_up_number', value: 1, enable: 't')
})
