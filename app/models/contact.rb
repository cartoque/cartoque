class Contact < ActiveRecord::Base
  has_many :contact_infos, :dependent => :destroy
  has_many :email_infos, :class_name => "ContactInfo", :conditions => {:info_type => "email"}
  accepts_nested_attributes_for :email_infos, :reject_if => lambda{|a| a[:value].blank? }, :allow_destroy => true
  has_many :phone_infos, :class_name => "ContactInfo", :conditions => {:info_type => "phone"}
  accepts_nested_attributes_for :phone_infos, :reject_if => lambda{|a| a[:value].blank? }, :allow_destroy => true

  belongs_to :company

  validates_presence_of :first_name, :last_name, :image_url

  def company_name
    company.try(:name)
  end

  def company_name=(name)
    self.company = Company.find_or_create_by_name(name) if name.present?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    initials = first_name.gsub(/(?:^|[ -.])(.)[^ -.]*/){ $1.upcase }
    "#{initials} #{last_name.capitalize}"
  end

  def full_position
    [job_position, company].reject(&:blank?).join(", ")
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
end
