module Contactable
  def self.included(base)
    base.class_eval do
      has_many :contact_infos, :dependent => :destroy, :as => :entity
      has_many :email_infos, :class_name => "ContactInfo", :conditions => {:info_type => "email"}, :as => :entity
      accepts_nested_attributes_for :email_infos, :reject_if => lambda{|a| a[:value].blank? }, :allow_destroy => true
      has_many :phone_infos, :class_name => "ContactInfo", :conditions => {:info_type => "phone"}, :as => :entity
      accepts_nested_attributes_for :phone_infos, :reject_if => lambda{|a| a[:value].blank? }, :allow_destroy => true
    end
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
