class Company < ActiveRecord::Base
  has_many :contacts, :dependent => :nullify
  include Contactable

  validates_presence_of :name

  scope :maintainers, where(:is_maintainer => true)

  def to_s
    name
  end

  def self.available_images
    %w(building.png
       premium_support.png
       house_one.png
       agp.png)
  end

  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      scoped
    end
  end
end
