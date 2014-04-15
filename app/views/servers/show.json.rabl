object @server

attributes :id, :name, :ip
node(:hypervisor_name) { |server| server.hypervisor.try(:name) }

# hardware details
attributes :memory_GB
attributes :processor_system_count,
           :processor_reference,
           :processor_frequency_GHz

#extended
attributes :extended_attributes

#operating system
child(:operating_system) do
  attributes :id, :name, :codename
end

#timestamps
attributes :created_at
attributes :updated_at
