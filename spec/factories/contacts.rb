Factory.define :contact do |m|
  m.first_name 'John'
  m.last_name  'Doe'
  m.job_position 'CEO'
  m.company { Factory(:company) }
end
