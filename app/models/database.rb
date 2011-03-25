class Database < ActiveRecord::Base
  attr_accessible :name
  has_many :machines
end
