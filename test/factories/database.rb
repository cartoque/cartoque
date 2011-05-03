Factory.define :database do |s|
  s.name "database-01"
  s.database_type "postgres"
  s.machine_ids [Factory(:machine).id]
end

Factory.define :oracle, :parent => :database do |s|
  s.name "database-02"
  s.database_type "oracle"
  s.machine_ids [Factory(:virtual).id]
end
