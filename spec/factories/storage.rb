Factory.define :storage do |s|
  s.server_id { Factory(:server).id }
  s.constructor "IBM"
end
