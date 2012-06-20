collection @servers, root: :servers, object_root: false

attributes :id, :name
node(:hypervisor_name) { |server| server.hypervisor.try(:name) }

# hardware details
attributes :memory_GB
attributes :processor_system_count,
           :processor_reference,
           :processor_frequency_GHz

#extended
attributes :extended_attributes
