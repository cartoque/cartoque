Factory.define :user do |m|
  m.uid 'admin'
  m.name 'Administrateur Datacenter'
  m.provider 'CAS'
end

Factory.define :bob, :class => User do |m|
  m.uid 'bob'
  m.name 'Bob'
  m.provider 'CAS'
end
