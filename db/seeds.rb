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

#fill ApplicationInstance if needed
if ApplicationInstance.count == 0 && Application.count > 0
  Application.all.each do |application|
    ApplicationInstance.find_or_create_by_name_and_application_id("prod", application.id)
    ApplicationInstance.find_or_create_by_name_and_application_id("ecole", application.id) if application.read_attribute(:pe).include?("E")
  end
end

#migrate application servers old links
if db.table_exists?("applications_servers")
  results = Server.connection.execute("SELECT application_id, server_id from applications_servers;").to_a
  results.each do |result|
    application_id, server_id = result
    prod_instance = ApplicationInstance.find_by_name_and_application_id("prod", application_id)
    if prod_instance && !prod_instance.server_ids.include?(server_id) && m=Server.find_by_id(server_id)
      prod_instance.servers << m
      prod_instance.save
    end
  end
end

#set default authentication method
if ApplicationInstance.where("authentication_method" => nil).count > 0
  ApplicationInstance.all.each do |app_instance|
    if app_instance.name == "prod" && app_instance.application.cerbere
      app_instance.update_attribute("authentication_method", "cerbere")
    else
      app_instance.update_attribute("authentication_method", "none")
    end
  end
end

#set servers identifier
Server.where(:identifier => nil).each do |m|
  m.update_attribute(:identifier, Server.identifier_for(m.name))
end

#populate CIs if needed
ActiveRecord::Base.subclasses.select do |klass|
  klass != ConfigurationItem && klass.instance_methods.include?(:configuration_item)
end.each do |klass|
  klass.all.each do |item|
    ConfigurationItem.generate_ci_for(item) if item.configuration_item.blank?
  end
end
