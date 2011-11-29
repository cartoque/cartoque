class Company < ActiveRecord::Base
  has_many :contacts, :dependent => :nullify
  validates_presence_of :name

  def to_s
    name
  end

  def self.available_images
    %w(building.png
       premium_support.png
       house_one.png
       agp.png)
  end

  def self.available_images_hash
    hsh = {}
    available = self.available_images
    available.each_with_index do |img, idx|
      hsh[img] = available[idx+1] || available[0]
    end
    hsh
  end

  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      scoped
    end
  end
end
