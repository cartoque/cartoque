class Storage < ActiveRecord::Base
  belongs_to :machine

  validates_presence_of :machine
  validates_presence_of :constructor

  def self.supported_types
    ["IBM", "NetApp", "Equalogic"]
  end
end
