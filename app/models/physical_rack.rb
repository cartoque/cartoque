class PhysicalRack < ActiveRecord::Base

  STATUS_PROD = 1
  STATUS_STOCK = 2

  has_many :servers
  belongs_to :site

  attr_accessible :name, :site_id, :status

  default_scope includes('site')
  scope :stock, where("physical_racks.status = ?", STATUS_STOCK)
  scope :non_stock, where("physical_racks.status != ?", STATUS_STOCK)

  def to_s
    [site,name].compact.join(" - ")
  end

  def stock?
    status == STATUS_STOCK
  end
end
