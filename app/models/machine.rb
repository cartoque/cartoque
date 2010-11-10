class Machine < ActiveRecord::Base
  has_and_belongs_to_many :applications

  attr_accessible :theme_id, :service_id, :os_id, :site_id, :rack_id, :cddvd_id, :mainteneur_id, :nom, :ancien_nom, :sousreseau_ip, :quatr_octet, :numero_serie, :virtuelle, :description, :modele, :memoire, :frequence, :date_mes, :fin_garantie, :type_contrat, :type_disque, :taille_disque, :marque, :ref_proc, :type_serveur, :nb_proc, :nb_coeur, :nb_rj45, :fc, :iscsi, :type_disque_alt, :taille_disque_alt, :nb_disque, :nb_disque_alt

  def ip
    i = sousreseau_ip.split(".")
    i << quatr_octet.gsub(".","")
    i.compact.join(".")
  end

  def ip=(value)
    if value.scan(/^((?:\d+\.){3})\.(\d+)/)
      self.sousreseau_ip = $1
      self.quatr_octet = $2
    end
  end
end
