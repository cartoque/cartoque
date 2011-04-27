class Machine < ActiveRecord::Base
  has_and_belongs_to_many :applications
  belongs_to :theme
  belongs_to :physical_rack
  belongs_to :service
  belongs_to :operating_system
  belongs_to :site
  belongs_to :media_drive
  belongs_to :mainteneur
  belongs_to :database
  has_one :storage

  attr_accessible :theme_id, :service_id, :operating_system_id, :site_id, :physical_rack_id, :media_drive_id, :mainteneur_id, :nom, :ancien_nom, :sousreseau_ip, :quatr_octet, :numero_serie, :virtuelle, :description, :modele, :memoire, :frequence, :delivered_on, :maintained_until, :type_contrat, :type_disque, :taille_disque, :marque, :ref_proc, :type_serveur, :nb_proc, :nb_coeur, :nb_rj45, :nb_fc, :nb_iscsi, :type_disque_alt, :taille_disque_alt, :nb_disque, :nb_disque_alt, :ip, :application_ids, :database_id

  default_scope :include => [:applications, :site, :theme, :service, :operating_system, :mainteneur, :physical_rack]
  scope :by_rack, proc {|rack_id| { :conditions => { :physical_rack_id => rack_id } } }
  scope :by_mainteneur, proc {|mainteneur_id| { :conditions => { :mainteneur_id => mainteneur_id } } }

  validates_presence_of :nom

  def ip
    i = sousreseau_ip.to_s.split(".")
    i << quatr_octet.to_s.gsub(".","")
    i.compact.join(".")
  end

  def ip=(value)
    if value.match(/^((?:\d+\.){3})(\d+)/)
      self.sousreseau_ip = $1.first(-1)
      self.quatr_octet = $2
    end
  end

  def self.search(search)
    if search
      where("nom LIKE ?", "%#{search}%")
    else
      scoped
    end
  end

  def cpu
    html = ""
    if nb_proc.present? && nb_proc > 0
      html << "#{nb_proc} * " unless nb_proc == 1
      html << "#{nb_coeur} cores, #{frequence} GHz"
      html << "<br />(#{ref_proc})" if ref_proc.present?
    else
      html << "?"
    end
    html.html_safe
  end

  def disks
    html = ""
    if taille_disque.present? && taille_disque > 0
      html << "#{nb_disque} * " unless nb_disque.blank? || nb_disque == 1
      html << "#{taille_disque}G"
      html << " (#{type_disque})" unless type_disque.blank?
      if taille_disque_alt.present? && taille_disque_alt > 0
        html << "<br />"
        html << "#{nb_disque_alt} * " unless nb_disque_alt.blank? || nb_disque_alt == 1
        html << "#{taille_disque_alt}G"
        html << " (#{type_disque_alt})" unless type_disque_alt.blank?
      end
    else
      html << "?"
    end
    html.html_safe
  end

  def localization
    [site, physical_rack].compact.join(" - ")
  end

  def fullmodel
    [marque, modele].join(" ")
  end

  def postgres_file
    File.expand_path("data/postgres/#{nom.downcase}.txt", Rails.root)
  end

  def postgres_report
    File.exists?(postgres_file) ? JSON.parse(File.read(postgres_file)) : []
  end

  def oracle_file
    File.expand_path("data/oracle/#{nom.downcase}.txt", Rails.root)
  end

  def oracle_report
    File.exists?(oracle_file) ? JSON.parse(File.read(oracle_file)) : []
  end
end
