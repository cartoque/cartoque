# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#a DB connection
db = ActiveRecord::Base.connection

#downcase server names
#TODO: add a validation on the name
Server.all.each do |server|
  server.update_attribute("name", server.name.downcase)
end

#set servers identifier
Server.where(:identifier => nil).each do |m|
  m.update_attribute(:identifier, Server.identifier_for(m.name))
end

#populate Server#network_device if needed
if Server.network_devices.none? && PhysicalLink.any?
  Server.find( PhysicalLink.select("distinct(switch_id)").map(&:switch_id) ).each do |switch|
    switch.update_attribute(:network_device, true)
  end
end

#populate CIs if needed
ActiveRecord::Base.subclasses.select do |klass|
  klass != ConfigurationItem && klass.instance_methods.include?(:configuration_item)
end.each do |klass|
  klass.all.each do |item|
    ConfigurationItem.generate_ci_for(item) if item.configuration_item.blank?
  end
end
