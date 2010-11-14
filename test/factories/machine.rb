Factory.define :machine do |m|
  m.nom 'server-01'
  m.sousreseau_ip '192.168.0'
  m.quatr_octet '10'
  m.virtuelle false
end

Factory.define :virtual, :parent => :machine do |m|
  m.nom 'v-server-01'
  m.virtuelle true
end
