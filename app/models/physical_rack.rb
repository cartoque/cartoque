class PhysicalRack < ActiveRecord::Base
  has_many :machines

  default_scope order('name')

  def to_s
    name
  end
end
