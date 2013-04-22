class Upgrade
  include Mongoid::Document
  include Mongoid::Timestamps
  include ConfigurationItem

  field :packages_list, type: Array
  field :strategy, type: String
  field :count_total, type: Integer, default: 0
  field :count_needing_reboot, type: Integer, default: 0
  field :count_important, type: Integer, default: 0
  field :count_normal, type: Integer, default: 0
  field :upgraded_status, type: Boolean
  field :server_name, type: String
  field :rebootable, type: Boolean, default: true
  belongs_to :server
  belongs_to :upgrader, class_name: 'User'

  before_save :cache_associations_fields
  before_save :update_counters!

  scope :by_server, proc { |name| where(server_name: Regexp.mask(name)) }
  scope :by_package, proc { |name| where(:packages_list.elem_match => { name: Regexp.mask(name) }) }
  scope :by_any_package, proc { |yes| yes == "1" ? where(:count_total.gt => 0) : scoped }

  validates_presence_of :server

  def to_s
    server.name
  end

  def update_counters!
    self.packages_list ||= []
    packages_by_status = self.packages_list.group_by do |package|
      package["status"]
    end
    self.count_total = self.packages_list.count
    self.count_needing_reboot = (packages_by_status["needing_reboot"] || []).count
    self.count_important = (packages_by_status["important"] || []).count
    self.count_normal = (packages_by_status["normal"] || []).count
  end

  private
  def cache_associations_fields
    self.server_name = self.server.try(:name)
  end
end
