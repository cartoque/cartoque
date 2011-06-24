class NormalizeMachinesIpAddresses < ActiveRecord::Migration
  def self.up
    add_column :machines, :ipaddress, :integer, :limit => 8
    Machine.reset_column_information
    Machine.all.each do |machine|
      begin
        machine.update_attribute(:ipaddress, machine.ip)
      rescue ArgumentError
        $stderr.puts "  WARNING: Unable to save #{machine.name} => #{machine.ip}"
      end
    end
  end

  def self.down
    remove_column :machines, :ipaddress
  end
end
