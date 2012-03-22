class PhysicalRack
  include Mongoid::Document

  field :name, type: String
  field :site_name, type: String
  field :status, type: Integer
  belongs_to :site
  has_many :servers, class_name: 'MongoServer'

  before_save :fill_in_site_name

  STATUS_PROD = 1
  STATUS_STOCK = 2

  def to_s
    [site_name, name].compact.join(" - ")
  end

  def stock?
    status == STATUS_STOCK
  end

  protected
  def fill_in_site_name
    self.site_name = self.site.try(:name)
  end
end
