class Database < ActiveRecord::Base
  attr_accessible :name, :machine_ids
  has_many :machines
end
