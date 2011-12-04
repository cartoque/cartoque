class Company < ActiveRecord::Base
  has_many :contacts, :dependent => :nullify
  has_many :contact_infos, :dependent => :destroy, :as => :entity
  has_many :email_infos, :class_name => "ContactInfo", :conditions => {:info_type => "email"}, :as => :entity
  accepts_nested_attributes_for :email_infos, :reject_if => lambda{|a| a[:value].blank? }, :allow_destroy => true
  has_many :phone_infos, :class_name => "ContactInfo", :conditions => {:info_type => "phone"}, :as => :entity
  accepts_nested_attributes_for :phone_infos, :reject_if => lambda{|a| a[:value].blank? }, :allow_destroy => true

  validates_presence_of :name

  def to_s
    name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    initials = first_name.gsub(/(?:^|[ -.])(.)[^ -.]*/){ $1.upcase }
    "#{initials} #{last_name.capitalize}"
  end

  def phone
    phone_infos.first
  end

  def email
    email_infos.first
  end

  def short_email
    "#{email}".gsub(/(.+)@([^@]+)$/) do
      $1+"@"+$2.gsub(/.*(\.[^.]+\.[^.]+)/, '..\1')
    end
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
