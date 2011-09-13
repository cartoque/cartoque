class NssDisk < ActiveRecord::Base
  belongs_to :server

  scope :by_server, proc { |server_id| where(:server_id => server_id) }
  scope :by_owner, proc { |owner| where(:owner => owner) }
  scope :by_name, proc { |search| where("nss_disks.name LIKE ?", "%#{search}%") }
  scope :by_type, proc { |type| where(:falconstor_type => type) }
  scope :by_guid, proc { |search| where("guid LIKE ?", "%#{search}%") }
end
