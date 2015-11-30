collection @servers, root: :servers, object_root: false

attributes :id, :name, :ipaddress, :operating_system_name, :arch, :virtual?
node(:hypervisor_name) { |server| server.hypervisor.try(:name) }

# hardware details
attributes :memory_GB
attributes :processor_system_count,
           :processor_reference,
           :processor_frequency_GHz

#extended
attributes :extended_attributes

#timestamps
attributes :created_at
attributes :updated_at

