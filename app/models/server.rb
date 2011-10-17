class Server < ActiveRecord::Base
  has_and_belongs_to_many :application_instances
  belongs_to :physical_rack
  belongs_to :operating_system
  belongs_to :media_drive
  belongs_to :mainteneur
  belongs_to :database
  has_one :storage
  has_many :ipaddresses, :dependent => :destroy
  has_many :physical_links, :dependent => :destroy, :class_name => 'PhysicalLink', :foreign_key => 'server_id'
  has_many :connected_links, :dependent => :destroy, :class_name => 'PhysicalLink', :foreign_key => 'switch_id'
  has_one :configuration_item, :as => :item
  has_many :cronjobs, :dependent => :destroy
  has_many :nss_volumes, :dependent => :destroy
  has_many :nss_disks, :dependent => :destroy
  has_many :nss_associations, :dependent => :destroy
  has_many :used_nss_volumes, :through => :nss_associations, :source => :nss_volume
  has_many :exported_disks, :class_name => "NetworkDisk", :dependent => :destroy
  has_many :network_filesystems, :class_name => "NetworkDisk", :foreign_key => "client_id", :dependent => :destroy
  belongs_to :hypervisor, :class_name => "Server"
  has_many :virtual_machines, :class_name => "Server", :foreign_key => "hypervisor_id"

  accepts_nested_attributes_for :ipaddresses, :reject_if => lambda{|a| a[:address].blank? },
                                              :allow_destroy => true
  accepts_nested_attributes_for :physical_links, :reject_if => lambda{|a| a[:link_type].blank? || a[:switch_id].blank? },
                                                 :allow_destroy => true

  attr_accessible :operating_system_id, :physical_rack_id, :media_drive_id, :mainteneur_id, :name,
                  :previous_name, :subnet, :lastbyte, :serial_number, :virtual, :description, :model, :memory, :frequency,
                  :delivered_on, :maintained_until, :contract_type, :disk_type, :disk_size, :manufacturer, :ref_proc,
                  :server_type, :nb_proc, :nb_coeur, :nb_rj45, :nb_fc, :nb_iscsi, :disk_type_alt, :disk_size_alt, :nb_disk,
                  :nb_disk_alt, :ipaddress, :application_instance_ids, :database_id, :ipaddresses_attributes, :has_drac,
                  :physical_links_attributes, :network_device, :hypervisor_id, :is_hypervisor, :puppetversion,
                  :rubyversion, :facterversion, :operatingsystemrelease
  attr_accessor   :just_created

  acts_as_ipaddress :ipaddress

  scope :by_rack, proc {|rack_id| { :conditions => { :physical_rack_id => rack_id } } }
  scope :by_site, proc {|site_id| joins(:physical_rack).where("physical_racks.site_id" => site_id) }
  scope :by_location, proc {|location|
    if location.match /^site-(\d+)/
      by_site($1)
    elsif location.match /^rack-(\d+)/
      by_rack($1)
    else
      scoped
    end
  }
  scope :by_mainteneur, proc {|mainteneur_id| { :conditions => { :mainteneur_id => mainteneur_id } } }
  scope :by_system, proc {|system_id| { :conditions => { :operating_system_id => OperatingSystem.find(system_id).subtree.map(&:id) } } }
  scope :by_virtual, proc {|virtual| { :conditions => { :virtual => (virtual.to_s == "1") } } }
  scope :by_puppet, proc {|puppet| (puppet.to_i != 0) ? where("puppetversion IS NOT NULL") : where("puppetversion IS NULL") }
  scope :by_osrelease, proc {|version| where(:operatingsystemrelease => version) }
  scope :by_puppetversion, proc {|version| where(:puppetversion => version) }
  scope :by_facterversion, proc {|version| where(:facterversion => version) }
  scope :by_rubyversion, proc {|version| where(:rubyversion => version) }
  scope :network_devices, where(:network_device => true)
  scope :hypervisor_hosts, where(:is_hypervisor => true)

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :identifier

  before_validation :sanitize_attributes
  before_validation :update_identifier
  before_save :update_main_ipaddress

  def self.find(*args)
    if args.first && args.first.is_a?(String) && !args.first.match(/^\d*$/)
      server = find_by_identifier(*args)
      raise ActiveRecord::RecordNotFound, "Couldn't find Server with identifier=#{args.first}" if server.nil?
      server
    else
      super
    end
  end

  def self.find_or_generate(name)
    server = Server.find_by_name(name) || Server.find_by_identifier(name)
    if server.blank?
      server = Server.create(:name => name)
      server.just_created = true
    end
    server
  end

  def just_created
    @just_created || false
  end

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

  def sanitize_attributes
    self.name = self.name.strip
  end

  def update_identifier
    self.identifier = Server.identifier_for(self.name)
  end

  def self.identifier_for(name)
    name.downcase.gsub(/[^a-z0-9_-]/,"-")
                 .gsub(/--+/, "-")
                 .gsub(/^-|-$/,"")
  end

  def update_main_ipaddress
    if ip = self.ipaddresses.detect{|ip| ip.main?}
      self.ipaddress = ip.address
    else
      self.send(:write_attribute, :ipaddress, nil)
    end
  end

  def self.search(search)
    if search
      where("servers.name LIKE ?", "%#{search}%")
    else
      scoped
    end
  end

  def cores
    html = ""
    html << "#{nb_proc} * " unless nb_proc == 1
    html << "#{nb_coeur} cores, " unless nb_coeur.blank? || nb_coeur <= 1
    html << "#{frequency} GHz"
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
    safe_json_parse(postgres_file)
  end

  def oracle_file
    File.expand_path("data/oracle/#{name.downcase}.txt", Rails.root)
  end

  def oracle_report
    safe_json_parse(oracle_file, [])
  end

  def safe_json_parse(file, default_value = [])
    if File.exists?(file)
      begin
        JSON.parse(File.read(file))
      rescue JSON::ParserError => e
        default_value
      end
    else
      default_value
    end
  end

  def tomcats
    @tomcats ||= Tomcat.find_for_server(self.name)
  end
end
