Factory.define :database do |s|
  s.name "database-01"
  s.database_type "postgres"
  s.machine_ids [Factory(:machine).id]
end
