class NssVolume < ActiveRecord::Base
  belongs_to :server
  serialize :attrs

  scope :by_server, proc { |server_id| where(:server_id => server_id) }
end
