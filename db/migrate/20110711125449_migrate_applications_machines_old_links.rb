class MigrateApplicationsMachinesOldLinks < ActiveRecord::Migration
  def self.up
     results = Machine.connection.execute("SELECT application_id, machine_id from applications_machines;").to_a
     results.each do |result|
       application_id, machine_id = result
       prod_instance = ApplicationInstance.find_by_name_and_application_id("prod", application_id)
       if prod_instance && !prod_instance.machine_ids.include?(machine_id) && m=Machine.find_by_id(machine_id)
         prod_instance.machines << m
         prod_instance.save
       end
     end
  end

  def self.down
  end
end
