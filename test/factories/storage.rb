Factory.define :storage do |s|
  s.machine_id Factory(:machine).id
  s.constructor "IBM"
end
