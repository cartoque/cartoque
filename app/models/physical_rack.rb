class PhysicalRack < ActiveRecord::Base
  has_many :servers
  belongs_to :site

  attr_accessible :name, :site_id

  default_scope includes('site').except(:order).order('sites.name, physical_racks.name')

  def to_s
    [site,name].compact.join(" - ")
  end
end
