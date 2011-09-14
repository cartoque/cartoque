class Cronjob < ActiveRecord::Base
  belongs_to :server

  scope :by_server, proc { |server_id| where(:server_id => server_id) }
  scope :by_name, proc { |search| where("cronjobs.name LIKE ?", "%#{search}%") }
  scope :by_command, proc { |search| where("cronjobs.command LIKE ?", "%#{search}%") }
end
