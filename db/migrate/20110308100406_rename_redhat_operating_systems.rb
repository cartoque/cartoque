class RenameRedhatOperatingSystems < ActiveRecord::Migration
  def self.up
    OperatingSystem.where("nom like 'RHEL%'").each do |system|
      if system.nom.match(/RHEL\s+(\S+)/)
        system.nom = "RedHat - RHEL #{$1}"
        system.save
      end
    end
  end

  def self.down
    OperatingSystem.where("nom like 'RHEL%'").each do |system|
      if system.nom.match(/RHEL\s+(\S+)/)
        system.nom = "RHEL #{$1}  - Red Hat Enterprise Linux #{$1}"
        system.save
      end
    end
  end
end
