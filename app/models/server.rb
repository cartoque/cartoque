class Server
  include Mongoid::Document
  include Mongoid::Timestamps
  include Acts::Ipaddress

  #some constants for status codes
  STATUS_ACTIVE = 1
  STATUS_INACTIVE = 2

  #specify the mongodb collection for now..
  #TODO: remove it when this class is renamed Server
  store_in :servers

  #standard fields
  field :name, type: String
  field :serial_number, type: String
  field :virtual, type: Boolean
  field :description, type: String
  field :model, type: String
  field :contract_type, type: String
  field :disk_type, type: String
  field :disk_size, type: Integer
  field :manufacturer, type: String
  field :server_type, type: String
  field :nb_rj45, type: Integer
  field :nb_fc, type: Integer
  field :nb_iscsi, type: Integer
  field :disk_type_alt, type: String
  field :disk_size_alt, type: Integer
  field :nb_disk, type: Integer
  field :nb_disk_alt, type: Integer
  field :delivered_on, type: Date
  field :maintained_until, type: Date
  field :ipaddress, type: Integer
  acts_as_ipaddress :ipaddress
  field :has_drac, type: Boolean
  field :ci_identifier, type: String
  field :network_device, type: Boolean
  field :is_hypervisor, type: Boolean
  field :puppetversion, type: String
  field :facterversion, type: String
  field :rubyversion, type: String
  field :operatingsystemrelease, type: String
  field :status, type: Integer, default: STATUS_ACTIVE
  field :arch, type: String
  field :processor_reference, type: String
  field :processor_frequency_GHz, type: Float, default: 0
  field :processor_system_count, type: Integer, default: -> { default_processor_system_count }
  field :processor_physical_count, type: Integer, default: 1
  field :processor_cores_per_cpu, type: Integer, default: 1
  field :memory_GB, type: Float, default: 0
  #associations
  belongs_to :operating_system
  belongs_to :physical_rack
  belongs_to :site
  belongs_to :media_drive
  belongs_to :database
  belongs_to :maintainer,       class_name: "Company", inverse_of: :maintained_servers
  belongs_to :hypervisor,       class_name: "Server",  inverse_of: :virtual_machines
  has_many   :virtual_machines, class_name: "Server", inverse_of: :hypervisor
  has_and_belongs_to_many :application_instances
  has_many :backup_jobs, dependent: :destroy
  has_and_belongs_to_many :backup_exceptions
  has_and_belongs_to_many :licenses, inverse_of: :servers
  has_many :cronjobs, dependent: :destroy, foreign_key: 'server_id'
  has_one :upgrade, dependent: :destroy, foreign_key: 'server_id'
  has_one :storage
  has_many :exported_disks,      class_name: 'NetworkDisk', foreign_key: 'server_id', dependent: :destroy
  has_many :network_filesystems, class_name: 'NetworkDisk', foreign_key: 'client_id', dependent: :destroy
  has_many :physical_links,      class_name: 'PhysicalLink', foreign_key: 'server_id', dependent: :destroy
  has_many :connected_links,     class_name: 'PhysicalLink', foreign_key: 'switch_id', dependent: :destroy
  has_many :ipaddresses, foreign_key: 'server_id', dependent: :destroy

  before_save :update_site!

  accepts_nested_attributes_for :ipaddresses, reject_if: lambda{|a| a[:address].blank? },
                                              allow_destroy: true
  accepts_nested_attributes_for :physical_links, reject_if: lambda{|a| a[:link_type].blank? || a[:switch_id].blank? },
                                                 allow_destroy: true

  attr_accessor :just_created


  scope :active, where(status: STATUS_ACTIVE)
  scope :inactive, where(status: STATUS_INACTIVE)
  scope :real_servers, where(:network_device.ne => true)
  scope :network_devices, where(network_device: true)
  scope :hypervisor_hosts, where(is_hypervisor: true)
  scope :by_rack, proc {|rack_id| where(physical_rack_id: rack_id) }
  scope :by_site, proc {|site_id| where(site_id: site_id) }
  scope :by_location, proc {|location|
    if location.match /^site-(\w+)/
      by_site($1)
    elsif location.match /^rack-(\w+)/
      by_rack($1)
    else
      scoped
    end
  }
  scope :by_maintainer, proc {|maintainer_id| where(maintainer_id: maintainer_id) }
  scope :by_system, proc {|system_id| where(:operating_system_id.in => OperatingSystem.find(system_id).subtree.map(&:to_param)) }
  scope :by_virtual, proc {|virtual| where(virtual: (virtual.to_s == "1")) }
  scope :by_puppet, proc {|puppet| puppet.to_i != 0 ? where(:puppetversion.exists => true).and(:puppetversion.ne => nil) : where(:puppetversion => nil) }
  scope :by_osrelease, proc {|version| where(operatingsystemrelease: version) }
  scope :by_puppetversion, proc {|version| where(puppetversion: version) }
  scope :by_facterversion, proc {|version| where(facterversion: version) }
  scope :by_rubyversion, proc {|version| where(rubyversion: version) }
  scope :by_serial_number, proc {|term| where(serial_number: Regexp.mask(term)) }
  scope :by_arch, proc {|arch| where(arch: arch) }
  scope :by_fullmodel, proc{|model| mask = Regexp.mask(model); any_of({ manufacturer: mask }, { model: mask }) }

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :ci_identifier

  before_validation :sanitize_attributes
  before_validation :update_ci_identifier
  before_save :update_main_ipaddress

  def self.find(*args)
    where(ci_identifier: args.first).first || super(*args)
  end

  def self.find_or_generate(name)
    servername = name.dup
    Setting.dns_domains.strip.split(/\n|,/).each do |domain|
      servername.gsub!(".#{domain.strip}".gsub(/^\.\./, "."), "")
    end
    server = Server.where(name: servername).first || Server.where(ci_identifier: servername).first
    if server.blank?
      server = Server.create(name: servername)
      server.just_created = true
    end
    server
  end

  def self.not_backuped
    #first list the ones that don't need backups
    backuped = BackupJob.where(server_status: Server::STATUS_ACTIVE).distinct(:server_id).uniq
    exceptions = BackupException.only(:server_ids).map(&:server_ids).flatten.uniq
    net_devices = Server.network_devices.distinct(:_id)
    stock_servers = Server.all.select{|s| s.physical_rack && s.physical_rack.status == PhysicalRack::STATUS_STOCK}.map(&:id)
    dont_need_backup = backuped + exceptions + net_devices + stock_servers
    #now let's search the servers
    servers = Server.where(status: Server::STATUS_ACTIVE)
    servers = servers.where(:_id.nin => dont_need_backup) if dont_need_backup.any?
    servers.order_by(:name.asc)
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
    ci_identifier
  end

  #TODO: make it better!
  def sanitize_attributes
    self.name = "#{self.name}".strip
  end

  def update_ci_identifier
    self.ci_identifier = Server.ci_identifier_for(self.name)
  end

  def self.ci_identifier_for(name)
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

  def self.like(term)
    if term
      where(name: Regexp.mask(term))
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

  def update_site!
    self.site = self.physical_rack.try(:site)
  end

  #TODO: migrate it definitely to a better structure
  def hardware_model
    self.model
  end

  def memory_MB
    memory_GB.to_f * 1024
  end

  private
  def default_processor_system_count
    if processor_physical_count.to_i > 0
      if processor_cores_per_cpu.to_i > 0
        processor_cores_per_cpu * processor_physical_count
      else
        processor_physical_count
      end
    else
      1
    end
  end
end
