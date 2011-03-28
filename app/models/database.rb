class Database < ActiveRecord::Base
  attr_accessible :name, :machine_ids
  has_many :machines
  validates_presence_of :name
end
