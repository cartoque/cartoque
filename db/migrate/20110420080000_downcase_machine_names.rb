class DowncaseMachineNames < ActiveRecord::Migration
  def self.up
    Machine.all.each do |machine|
      machine.update_attribute("nom", machine.nom.downcase)
    end
  end

  def self.down
  end
end
