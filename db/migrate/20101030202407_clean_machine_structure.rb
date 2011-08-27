class CleanMachineStructure < ActiveRecord::Migration
  def self.up
    rename_column :machines, :machine_nom, :nom
    rename_column :machines, :machine_ancien_nom, :ancien_nom
    rename_column :machines, :virtuelle, :memoire_virtuelle
    rename_column :machines, :machine_description, :description
    rename_column :machines, :fc, :nb_fc
    rename_column :machines, :iscsi, :nb_iscsi
    rename_column :machines, :type_hd1, :type_disque_alt
    rename_column :machines, :disque_dur, :taille_disque
    rename_column :machines, :disque_dur1, :taille_disque_alt
    rename_column :machines, :nb_disque1, :nb_disque_alt
  end

  def self.down
    rename_column :machines, :nom, :machine_nom
    rename_column :machines, :ancien_nom, :machine_ancien_nom
    rename_column :machines, :memoire_virtuelle, :virtuelle
    rename_column :machines, :description, :machine_description
    rename_column :machines, :nb_fc, :fc
    rename_column :machines, :nb_iscsi, :iscsi
    rename_column :machines, :type_disque_alt, :type_hd1
    rename_column :machines, :taille_disque, :disque_dur
    rename_column :machines, :taille_disque_alt, :disque_dur1
    rename_column :machines, :nb_disque_alt, :nb_disque1
  end
end
