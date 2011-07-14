class AllowBlankValuesForJoinTables < ActiveRecord::Migration
  def self.up
    %w(theme_id service_id operating_system_id site_id physical_rack_id media_drive_id
       mainteneur_id taille_disque nb_proc nb_coeur nb_rj45 nb_fc nb_iscsi nb_disque
       taille_disque_alt nb_disque_alt).each do |item|
      change_column :machines, item, :integer, :default => 0, :null => true
    end
    change_column :applications, :criticite, :integer, :limit => 1, :default => 3, :null => true
  end

  def self.down
  end
end
