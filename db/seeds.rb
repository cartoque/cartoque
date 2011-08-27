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

#parse old dates in Machine
{:date_mes => :delivered_on, :fin_garantie => :maintained_until}.each do |old_field, new_field|
  if db.table_exists?(old_field) && db.table_exists?(new_field)
    Machine.all.each do |m|
      value = m.send(old_field)
      unless value.blank?
        value = "#{$1}/20#{$2}" if value.match %r{(.*\d\d)/(\d\d)$}
        m.update_attribute(new_field, (Date.parse(value) rescue nil))
      end
    end
  end
end

#downcase machine names
#TODO: add a validation on the name
Machine.all.each do |machine|
  machine.update_attribute("name", machine.name.downcase)
end

#automatically find database clusters
servers = Machine.where("name like 'sgbd%'")
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
Machine.where("name like 'gaston%'").each do |machine|
  Storage.create(:machine_id => machine.id, :constructor => "Equalogic")
end
#SAN IBM DS4500
Machine.where("name like 'rehdsk%'").each do |machine|
  Storage.create(:machine_id => machine.id, :constructor => "IBM") unless Storage.where(:machine_id => machine.id).exists?
end
#NAS
Storage.create(:machine => Machine.find_by_name("plomb"), :constructor => "NetApp")
Storage.create(:machine => Machine.find_by_name("antimoine"), :constructor => "NetApp")

#update Machine#ipaddress if possible
if db.column_exists?("machines", "ipaddress") && Machine.respond_to?(:ip)
  Machine.all.each do |machine|
    begin
      machine.update_attribute(:ipaddress, machine.ip)
    rescue ArgumentError
      $stderr.puts "  WARNING: Unable to save #{machine.name} => #{machine.ip}"
    end
  end
end

#fill Ipaddress table if needed
if Ipaddress.count == 0 && Machine.where("ipaddress is not null").count
  Machine.all.each do |machine|
    if machine.ipaddress
      machine.ipaddresses << Ipaddress.new(:address => machine.ipaddress, :main => true)
      machine.save
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

#migrate application machines old links
if db.table_exists?("applications_machines")
  results = Machine.connection.execute("SELECT application_id, machine_id from applications_machines;").to_a
  results.each do |result|
    application_id, machine_id = result
    prod_instance = ApplicationInstance.find_by_name_and_application_id("prod", application_id)
    if prod_instance && !prod_instance.machine_ids.include?(machine_id) && m=Machine.find_by_id(machine_id)
      prod_instance.machines << m
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

#set machines identifier
Machine.where(:identifier => nil).each do |m|
  m.update_attribute(:identifier, Machine.identifier_for(m.name))
end
