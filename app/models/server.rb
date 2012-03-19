class Server < ActiveRecord::Base
  STATUS_ACTIVE = 1
  STATUS_INACTIVE = 2

  belongs_to :media_drive
  belongs_to :maintainer, class_name: 'Company'
  belongs_to :database
  has_one :storage
  has_many :ipaddresses, dependent: :destroy
  has_many :physical_links, dependent: :destroy, class_name: 'PhysicalLink', foreign_key: 'server_id'
  has_many :connected_links, dependent: :destroy, class_name: 'PhysicalLink', foreign_key: 'switch_id'
  has_many :cronjobs, dependent: :destroy
  has_many :nss_volumes, dependent: :destroy
  has_many :nss_disks, dependent: :destroy
  has_many :nss_associations, dependent: :destroy
  has_many :used_nss_volumes, through: :nss_associations, source: :nss_volume
  has_many :exported_disks, class_name: "NetworkDisk", dependent: :destroy
  has_many :network_filesystems, class_name: "NetworkDisk", foreign_key: "client_id", dependent: :destroy
  belongs_to :hypervisor, class_name: "Server"
  has_many :virtual_machines, class_name: "Server", foreign_key: "hypervisor_id"
  has_many :backup_jobs, dependent: :destroy
  has_one :upgrade, dependent: :destroy

  accepts_nested_attributes_for :ipaddresses, reject_if: lambda{|a| a[:address].blank? },
                                              allow_destroy: true
  accepts_nested_attributes_for :physical_links, reject_if: lambda{|a| a[:link_type].blank? || a[:switch_id].blank? },
                                                 allow_destroy: true

  attr_accessible :operating_system_mongo_id, :physical_rack, :physical_rack_mongo_id, :media_drive_id, :maintainer_mongo_id, :name,
                  :previous_name, :subnet, :lastbyte, :serial_number, :virtual, :description, :model, :memory, :frequency,
                  :delivered_on, :maintained_until, :contract_type, :disk_type, :disk_size, :manufacturer, :ref_proc,
                  :server_type, :nb_proc, :nb_coeur, :nb_rj45, :nb_fc, :nb_iscsi, :disk_type_alt, :disk_size_alt, :nb_disk,
                  :nb_disk_alt, :ipaddress, :application_instance_ids, :database_id, :ipaddresses_attributes, :has_drac,
                  :physical_links_attributes, :network_device, :hypervisor_id, :is_hypervisor, :puppetversion,
                  :rubyversion, :facterversion, :operatingsystemrelease, :status, :identifier, :arch, :site_mongo_id
  attr_accessor   :just_created

  acts_as_ipaddress :ipaddress

  scope :active, where("servers.status" => STATUS_ACTIVE)
  scope :inactive, where("servers.status" => STATUS_INACTIVE)
  scope :real_servers, where(network_device: false)
  scope :network_devices, where(network_device: true)
  scope :hypervisor_hosts, where(is_hypervisor: true)
  scope :by_rack, proc {|rack_id| where(physical_rack_mongo_id: rack_id) }
  scope :by_site, proc {|site_id| where(site_mongo_id: site_id) }
  scope :by_location, proc {|location|
    if location.match /^site-(\w+)/
      by_site($1)
    elsif location.match /^rack-(\w+)/
      by_rack($1)
    else
      scoped
    end
  }
  scope :by_maintainer, proc {|maintainer_id| { conditions: { maintainer_mongo_id: maintainer_id } } }
  scope :by_system, proc {|system_id| { conditions: { operating_system_mongo_id: OperatingSystem.find(system_id).subtree.map(&:to_param) } } }
  scope :by_virtual, proc {|virtual| { conditions: { virtual: (virtual.to_s == "1") } } }
  scope :by_puppet, proc {|puppet| (puppet.to_i != 0) ? where("puppetversion IS NOT NULL") : where("puppetversion IS NULL") }
  scope :by_osrelease, proc {|version| where(operatingsystemrelease: version) }
  scope :by_puppetversion, proc {|version| where(puppetversion: version) }
  scope :by_facterversion, proc {|version| where(facterversion: version) }
  scope :by_rubyversion, proc {|version| where(rubyversion: version) }
  scope :by_serial_number, proc {|search| where("serial_number like ?", "%#{search}%") }
  scope :by_arch, proc {|arch| where(arch: arch) }
  scope :by_fullmodel, proc{|model| where("manufacturer like ? OR model like ?", "%#{model}%", "%#{model}%") }

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
    servername = name.dup
    Setting.dns_domains.strip.split(/\n|,/).each do |domain|
      servername.gsub!(".#{domain.strip}".gsub(/^\.\./, "."), "")
    end
    server = Server.unscoped.find_by_name(servername) || Server.unscoped.find_by_identifier(servername)
    if server.blank?
      server = Server.create(name: servername)
      server.just_created = true
    end
    server
  end

  def self.not_backuped
    #first list the ones that don't need backups
    backuped = BackupJob.includes(:server).where("servers.status" => Server::STATUS_ACTIVE).select("distinct(server_id)").map(&:server_id)
    exceptions = BackupException.includes(:servers).map(&:servers).flatten.map(&:id).uniq
    net_devices = Server.network_devices.select("id").map(&:id)
    stock_servers = Server.all.select{|s| s.physical_rack_mongo_id && s.physical_rack && s.physical_rack.status == PhysicalRack::STATUS_STOCK}.map(&:id)
    dont_need_backup = backuped + exceptions + net_devices + stock_servers
    #now let's search the servers
    servers = Server.where("servers.status" => Server::STATUS_ACTIVE)
    servers = servers.where("id not in (?)", dont_need_backup) unless dont_need_backup.empty?
    servers.order("name asc")
  end

  #TEMPORARY
  def application_instance_ids
    @application_instance_ids ||= ActiveRecord::Base.connection.execute(
      "SELECT application_instance_mongo_id FROM application_instances_servers WHERE server_id = '#{self.id}';"
    ).to_a.flatten
  end

  #TEMPORARY
  def application_instances
    @application_instances ||= ApplicationInstance.find(application_instance_ids)
  end

  #TEMPORARY
  def operating_system
    OperatingSystem.find(self.operating_system_mongo_id) rescue nil
  end

  def just_created
    @just_created || false
  end

  def active?
    status == STATUS_ACTIVE
  end

  def stock?
    physical_rack.present? && physical_rack.stock?
  end

  def to_s
    name
  end

  def to_param
    identifier
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

  def can_be_managed_with_puppet?
    operating_system.present? && operating_system.managed_with_puppet?
  end

  def physical_rack
    @physical_rack ||= PhysicalRack.find(self.physical_rack_mongo_id) rescue nil
  end

  def physical_rack=(rack)
    if rack.is_a?(PhysicalRack)
      self.physical_rack_mongo_id = rack.id.to_s
      self.site_mongo_id = rack.site_id.to_s
      @physical_rack = rack
    end
  end

  #TEMPORARY
  def license_ids
    ActiveRecord::Base.connection.execute("SELECT license_mongo_id FROM licenses_servers WHERE server_id=#{self.id};").to_a.flatten
  end

  #TEMPORARY
  def licenses
    License.where(id: license_ids)
  end

  #TEMPORARY
  def backup_exception_ids
    ActiveRecord::Base.connection.execute("SELECT backup_exception_mongo_id FROM backup_exceptions_servers WHERE server_id=#{self.id};").to_a.flatten
  end

  #TEMPORARY
  def backup_exceptions
    BackupException.where(id: backup_exception_ids)
  end
end
