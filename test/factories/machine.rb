Factory.define :machine do |m|
  m.name 'server-01'
  m.subnet '192.168.0'
  m.lastbyte '10'
  m.virtual false
end

Factory.define :virtual, :parent => :machine do |m|
  m.name 'v-server-01'
  m.virtual true
end
