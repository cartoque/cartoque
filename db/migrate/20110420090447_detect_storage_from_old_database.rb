class DetectStorageFromOldDatabase < ActiveRecord::Migration
  def self.up
    #SAN iSCSI PS5000/6000
    Machine.where("nom like 'gaston%'").each do |machine|
      Storage.create(:machine_id => machine.id, :constructor => "Equalogic")
    end
    #SAN IBM DS4500
    Machine.where("nom like 'rehdsk%' and sousreseau_ip != ''").each do |machine|
      Storage.create(:machine_id => machine.id, :constructor => "IBM")
    end
    #NAS
    Storage.create(:machine => Machine.find_by_nom("plomb"), :constructor => "NetApp")
    Storage.create(:machine => Machine.find_by_nom("antimoine"), :constructor => "NetApp")
  end

  def self.down
  end
end
