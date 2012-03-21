class Site
  include Mongoid::Document
  field :name, type: String

  validates_presence_of :name

  has_many :physical_racks

  def to_s
    name
  end

  after_save :update_physical_racks_site_name
  def update_physical_racks_site_name
    physical_racks.each do |rack|
      rack.save
    end
  end

  after_destroy :remove_physical_racks_site_name
  def remove_physical_racks_site_name
    physical_racks.each do |rack|
      rack.site_id = nil
      rack.save
    end
  end
end
