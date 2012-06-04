class Company < Contactable
  include Mongoid::Denormalize

  #standard fields
  field :name, type: String
  field :is_maintainer, type: Boolean
  #associations
  has_many :contacts, dependent: :nullify
  has_many :maintained_servers, class_name: 'Server', foreign_key: 'maintainer_id'
  #denormalized
  denormalize :name, to: :maintained_servers
  denormalize :email, to: :maintained_servers
  denormalize :phone, to: :maintained_servers

  validates_presence_of :name

  scope :maintainers, where(is_maintainer: true).order_by([:name.asc])

  def to_s
    name
  end

  def self.available_images
    %w(building.png
       premium_support.png
       house_one.png
       agp.png)
  end

  def self.like(term)
    if term
      where(name: Regexp.mask(term))
    else
      scoped
    end
  end
end
