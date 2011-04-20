class SetMachinesVirtualAttribute < ActiveRecord::Migration
  def self.up
    Machine.all.each do |m|
      if m.nom.match(/^(ar-|kr-|vm-|xe-|dev-|gesper\d\d-|vip-)/)
        m.virtuelle = true
        m.save
      end
    end
  end

  def self.down
  end
end
