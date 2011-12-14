class Upgrade < ActiveRecord::Base
  belongs_to :server
  serialize :packages_list
end
