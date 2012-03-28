class Company < Contactable
  field :name, type: String
  field :is_maintainer, type: Boolean

  has_many :contacts, dependent: :nullify
  has_many :maintained_servers, class_name: 'Server', foreign_key: 'maintainer_id'

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
