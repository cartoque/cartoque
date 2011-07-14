class NormalizeDatabaseFieldNames < ActiveRecord::Migration
  def self.up
    self.columns_list.each do |column|
      rename_column column[0], column[1], column[2]
    end
    self.reset_column_informations!
  end

  def self.down
    self.columns_list.each do |column|
      rename_column column[0], column[2], column[1]
    end
    self.reset_column_informations!
  end

  def self.columns_list
    [
      %w(applications nom name),
      %w(applications criticite criticity),
      %w(applications fiche comment),
      %w(machines nom name),
      %w(machines ancien_nom previous_name),
      %w(machines numero_serie serial_number),
      %w(machines sousreseau_ip subnet),
      %w(machines quatr_octet lastbyte),
      %w(machines modele model),
      %w(machines memoire memory),
      %w(machines frequence frequency),
      %w(machines type_contrat contract_type),
      %w(machines type_disque disk_type),
      %w(machines taille_disque disk_size),
      %w(machines nb_disque nb_disk),
      %w(machines type_disque_alt disk_type_alt),
      %w(machines taille_disque_alt disk_size_alt),
      %w(machines nb_disque_alt nb_disk_alt),
      %w(machines marque manufacturer),
      %w(machines type_serveur server_type),
      %w(machines virtuelle virtual),
      %w(mainteneurs nom name),
      %w(mainteneurs telephone phone),
      %w(mainteneurs mail email),
      %w(mainteneurs adresse address),
      %w(mainteneurs ref_client client_ref),
      %w(media_drives nom name),
      %w(operating_systems nom name),
      %w(physical_racks nom name),
      %w(services nom name),
      %w(sites nom name),
      %w(sousreseaux sousreseau_ip cidr_mask),
      %w(sousreseaux sousreseau_nom_logique name),
      %w(sousreseaux sousreseau_couleur_police color),
      %w(sousreseaux sousreseau_couleur_fond background_color),
      %w(themes titre name)
    ]
  end

  def self.reset_column_informations!
    [Application, Machine, Mainteneur, OperatingSystem, PhysicalRack, Service, Site, Theme].each do |klass|
      klass.reset_column_information
    end
  end
end
