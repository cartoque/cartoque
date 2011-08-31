# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#a DB connection
db = ActiveRecord::Base.connection

#set default database_type if needed
Database.update_all(:database_type => 'postgres', 'database_type' => nil)

#parse old dates in Server
{:date_mes => :delivered_on, :fin_garantie => :maintained_until}.each do |old_field, new_field|
  if db.table_exists?(old_field) && db.table_exists?(new_field)
    Server.all.each do |m|
      value = m.send(old_field)
      unless value.blank?
        value = "#{$1}/20#{$2}" if value.match %r{(.*\d\d)/(\d\d)$}
        m.update_attribute(new_field, (Date.parse(value) rescue nil))
      end
    end
  end
end

#downcase server names
#TODO: add a validation on the name
Server.all.each do |server|
  server.update_attribute("name", server.name.downcase)
end

#automatically find database clusters
servers = Server.where("name like 'sgbd%'")
servers.map do |s|
  s.name.gsub(/-\d*$/,"")
end.uniq.sort.reverse.each do |cluster|
  d = Database.find_or_create_by_name(cluster)
  d.update_attribute(:database_type, (cluster.match(/m2$|a$/i) ? "postgres" : "oracle"))
  servers.select{|s| s.name.starts_with?(cluster)}.each do |server|
    server.update_attribute("database_id", d.id)
  end
end

#automatically find storage devices
#SAN iSCSI PS5000/6000
Server.where("name like 'gaston%'").each do |server|
  Storage.create(:server_id => server.id, :constructor => "Equalogic")
end
#SAN IBM DS4500
Server.where("name like 'rehdsk%'").each do |server|
  Storage.create(:server_id => server.id, :constructor => "IBM") unless Storage.where(:server_id => server.id).exists?
end
#NAS
Storage.create(:server => Server.find_by_name("plomb"), :constructor => "NetApp")
Storage.create(:server => Server.find_by_name("antimoine"), :constructor => "NetApp")

#update Server#ipaddress if possible
if db.column_exists?("servers", "ipaddress") && Server.respond_to?(:ip)
  Server.all.each do |server|
    begin
      server.update_attribute(:ipaddress, server.ip)
    rescue ArgumentError
      $stderr.puts "  WARNING: Unable to save #{server.name} => #{server.ip}"
    end
  end
end

#fill Ipaddress table if needed
if Ipaddress.count == 0 && Server.where("ipaddress is not null").count
  Server.all.each do |server|
    if server.ipaddress
      server.ipaddresses << Ipaddress.new(:address => server.ipaddress, :main => true)
      server.save
    end
  end
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
