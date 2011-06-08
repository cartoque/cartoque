class Machine < ActiveRecord::Base
  has_and_belongs_to_many :applications
  belongs_to :theme
  belongs_to :physical_rack
  belongs_to :service
  belongs_to :operating_system
  belongs_to :media_drive
  belongs_to :mainteneur
  belongs_to :database
  has_one :storage

  attr_accessible :theme_id, :service_id, :operating_system_id, :physical_rack_id, :media_drive_id, :mainteneur_id, :name, :previous_name, :subnet, :lastbyte, :serial_number, :virtual, :description, :model, :memory, :frequency, :delivered_on, :maintained_until, :contract_type, :disk_type, :disk_size, :manufacturer, :ref_proc, :server_type, :nb_proc, :nb_coeur, :nb_rj45, :nb_fc, :nb_iscsi, :disk_type_alt, :disk_size_alt, :nb_disk, :nb_disk_alt, :ip, :application_ids, :database_id

  default_scope :include => [:applications, :operating_system, :mainteneur, :physical_rack]
  scope :by_rack, proc {|rack_id| { :conditions => { :physical_rack_id => rack_id } } }
  scope :by_mainteneur, proc {|mainteneur_id| { :conditions => { :mainteneur_id => mainteneur_id } } }
  scope :by_system, proc {|system_id| { :conditions => { :operating_system_id => system_id } } }

  validates_presence_of :name

  def to_s
    name
  end

  def ip
    i = subnet.to_s.split(".")
    i << lastbyte.to_s.gsub(".","")
    i.compact.join(".")
  end

  def ip=(value)
    if value.match(/^((?:\d+\.){3})(\d+)/)
      self.subnet = $1.first(-1)
      self.lastbyte = $2
    end
  end

  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      scoped
    end
  end

  def cores
    html = ""
    html << "#{nb_proc} * " unless nb_proc == 1
    html << "#{nb_coeur} cores, #{frequency} GHz"
    html.html_safe
  end

  def cpu
    html = ""
    if nb_proc.present? && nb_proc > 0
      html << cores
      html << "<br />(#{ref_proc})" if ref_proc.present?
    else
      html << "?"
    end
    html.html_safe
  end

  def disks
    html = ""
    if disk_size.present? && disk_size > 0
      html << "#{nb_disk} * " unless nb_disk.blank? || nb_disk == 1
      html << "#{disk_size}G"
      html << " (#{disk_type})" unless disk_type.blank?
      if disk_size_alt.present? && disk_size_alt > 0
        html << "<br />"
        html << "#{nb_disk_alt} * " unless nb_disk_alt.blank? || nb_disk_alt == 1
        html << "#{disk_size_alt}G"
        html << " (#{disk_type_alt})" unless disk_type_alt.blank?
      end
    else
      html << "?"
    end
    html.html_safe
  end

  def ram
    html = ""
    if memory.present? && memory.to_f > 0
      html = memory.to_s + (memory.to_s.match(/[MG]/) ? "Go" : "")
    else
      html << "?"
    end
    html
  end

  def localization
    physical_rack
  end

  def fullmodel
    [manufacturer, model].join(" ")
  end

  def postgres_file
    File.expand_path("data/postgres/#{name.downcase}.txt", Rails.root)
  end

  def postgres_report
    File.exists?(postgres_file) ? JSON.parse(File.read(postgres_file)) : []
  end

  def oracle_file
    File.expand_path("data/oracle/#{name.downcase}.txt", Rails.root)
  end

  def oracle_report
    File.exists?(oracle_file) ? JSON.parse(File.read(oracle_file)) : []
  end
end
