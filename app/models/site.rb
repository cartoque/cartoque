class Site
  include Mongoid::Document
  include Mongoid::Denormalize

  #standard fields
  field :name, type: String
  #denormalized fields
  denormalize :name, to: :physical_racks
  #associations
  has_many :physical_racks

  validates_presence_of :name

  def to_s
    name
  end
end
