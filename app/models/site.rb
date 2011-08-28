class Site < ActiveRecord::Base
  has_many :physical_racks

  attr_accessible :name

  default_scope order('name')

  def to_s
    name
  end
end
