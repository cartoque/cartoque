class Upgrade < ActiveRecord::Base
  belongs_to :server
  serialize :packages_list
  before_save :update_counters!

  scope :by_server, proc { |name| includes(:server).where("servers.name like ?", "%#{name}%") }
  scope :by_package, proc { |name| where("packages_list like ?", "%#{name}%") }

  def update_counters!
    self.packages_list ||= []
    packages_by_status = self.packages_list.group_by do |package|
      package[:status]
    end
    self.count_total = self.packages_list.count
    self.count_important = (packages_by_status["important"] || []).count
    self.count_needing_reboot = (packages_by_status["needing_reboot"] || []).count
  end
end
