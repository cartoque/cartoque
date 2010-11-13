class Machine < ActiveRecord::Base
  has_and_belongs_to_many :applications
  belongs_to :theme
  belongs_to :physical_rack
  belongs_to :service
  belongs_to :operating_system

  attr_accessible :theme_id, :service_id, :operating_system_id, :site_id, :physical_rack_id, :cddvd_id, :mainteneur_id, :nom, :ancien_nom, :sousreseau_ip, :quatr_octet, :numero_serie, :virtuelle, :description, :modele, :memoire, :frequence, :date_mes, :fin_garantie, :type_contrat, :type_disque, :taille_disque, :marque, :ref_proc, :type_serveur, :nb_proc, :nb_coeur, :nb_rj45, :nb_fc, :nb_iscsi, :type_disque_alt, :taille_disque_alt, :nb_disque, :nb_disque_alt, :ip, :application_ids

  default_scope :include => :applications

  def ip
    i = sousreseau_ip.to_s.split(".")
    i << quatr_octet.to_s.gsub(".","")
    i.compact.join(".")
  end

  def ip=(value)
    if value.scan(/^((?:\d+\.){3})(\d+)/)
      self.sousreseau_ip = $1.first(-1)
      self.quatr_octet = $2
    end
  end
end
