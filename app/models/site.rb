class Site < ActiveRecord::Base
  attr_accessible :name, :physical_racks

  default_scope order('name')

  validates_presence_of :name

  def to_s
    name
  end

  def physical_racks
    @physical_racks ||= PhysicalRack.where(:site_id => self.id)
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
