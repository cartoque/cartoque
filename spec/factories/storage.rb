Factory.define :storage do |s|
  s.server { Factory(:mongo_server) }
  s.constructor "IBM"
end
