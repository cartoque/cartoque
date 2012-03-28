collection @servers => :servers

attributes :id, :name
node(:hypervisor_name) { |server| server.hypervisor.try(:name) }
