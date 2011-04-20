class DowncaseMachineNames < ActiveRecord::Migration
  def self.up
    Machine.all.each do |machine|
      machine.nom = machine.nom.downcase
      machine.save
    end
  end

  def self.down
  end
end
