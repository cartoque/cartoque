class Site
  include Mongoid::Document
  include Mongoid::Alize
  include ConfigurationItem

  #standard fields
  field :name, type: String
  #associations
  has_many :physical_racks

  validates_presence_of :name

  after_destroy :propagate_site_name_to_servers

  def to_s
    name
  end

  protected
  # override mongoid_alize callback so that denormalizations
  # get properly propagated to physical rack's servers
  #
  # see mongoid_alize README for more informations
  def denormalize_to_physical_racks
    _denormalize_to_physical_racks
    propagate_site_name_to_servers
  end

  def propagate_site_name_to_servers
    physical_racks.each do |rack|
      rack.denormalize_to_servers
    end
  end
end
