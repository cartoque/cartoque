class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.integer :theme_id
      t.integer :service_id
      t.integer :os_id
      t.integer :site_id
      t.integer :rack_id
      t.integer :cddvd_id
      t.integer :mainteneur_id
      t.string :machine_nom
      t.string :machine_ancien_nom
      t.string :sousreseau_ip
      t.string :quatr_octet
      t.string :numero_serie
      t.integer :virtuelle
      t.text :machine_description
      t.string :modele
      t.string :memoire
      t.float :frequence
      t.string :date_mes
      t.string :fin_garantie
      t.string :type_contrat
      t.string :type_hd
      t.integer :disque_dur
      t.string :marque
      t.string :ref_proc
      t.string :type_serveur
      t.integer :nb_proc
      t.integer :nb_coeur
      t.integer :nb_rj45
      t.integer :fc
      t.integer :iscsi
      t.string :type_hd1
      t.integer :disque_dur1
      t.integer :nb_disque
      t.integer :nb_disque1

      t.timestamps
    end
  end

  def self.down
    drop_table :machines
  end
end
