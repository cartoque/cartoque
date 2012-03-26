Factory.define :storage do |s|
  s.server { Factory(:server) }
  s.constructor "IBM"
end
