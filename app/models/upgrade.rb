class Upgrade
  include Mongoid::Document
  include Mongoid::Timestamps

  field :packages_list, type: Array
  field :strategy, type: String
  field :count_total, type: Integer
  field :count_needing_reboot, type: Integer
  field :count_important, type: Integer
  field :upgraded_status, type: Boolean
  field :server_name, type: String
  belongs_to :server
  belongs_to :upgrader, class_name: 'User'

  before_save :cache_associations_fields
  before_save :update_counters!

  scope :by_server, proc { |name| where(servers_name: Regexp.new(name, Regexp::IGNORECASE)) }
  scope :by_package, proc { |name| where(:packages_list.matches => { name: Regexp.new(name, Regexp::IGNORECASE) }) }

  validates_presence_of :server

  def update_counters!
    self.packages_list ||= []
    packages_by_status = self.packages_list.group_by do |package|
      package[:status]
    end
    self.count_total = self.packages_list.count
    self.count_important = (packages_by_status["important"] || []).count
    self.count_needing_reboot = (packages_by_status["needing_reboot"] || []).count
  end

  private
  def cache_associations_fields
    self.server_name = self.server.try(:name)
  end
end
