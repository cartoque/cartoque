class Machine < ActiveRecord::Base
  attr_accessible :theme_id, :service_id, :os_id, :site_id, :rack_id, :cddvd_id, :mainteneur_id, :machine_nom, :machine_ancien_nom, :sousreseau_ip, :quatr_octet, :numero_serie, :virtuelle, :machine_description, :modele, :memoire, :frequence, :date_mes, :fin_garantie, :type_contrat, :type_hd, :disque_dur, :marque, :ref_proc, :type_serveur, :nb_proc, :nb_coeur, :nb_rj45, :fc, :iscsi, :type_hd1, :disque_dur1, :nb_disque, :nb_disque1
end
