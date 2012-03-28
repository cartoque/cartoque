object @server

attributes :id, :name, :ip
node(:hypervisor_name) { |server| server.hypervisor.try(:name) }
