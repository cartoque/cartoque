class Contactable
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::MultiParameterAttributes

  field :comment,   type: String
  field :image_url, type: String,   default: -> { self.class == Contact ? "ceo.png" : "building.png" }
  field :internal,  type: Boolean,  default: false
  embeds_many :email_infos,   as: :entity
  embeds_many :website_infos, as: :entity
  embeds_many :phone_infos,   as: :entity
  embeds_many :address_infos, as: :entity
  accepts_nested_attributes_for :email_infos, reject_if: lambda{|a| a[:value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :phone_infos, reject_if: lambda{|a| a[:value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :website_infos, reject_if: lambda{|a| a[:value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :address_infos, reject_if: lambda{|a| a[:value].blank? }, allow_destroy: true

  scope :with_internals, proc{|show_internals| show_internals ? scoped : where(internal: false) }
  scope :emailable, where(:email_infos.matches => { value: // })

  def contact_infos
    email_infos + website_infos + phone_infos + address_infos
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

  class << self
    def available_images_hash
      hsh = {}
      available = self.available_images
      available.each_with_index do |img, idx|
        hsh[img] = available[idx+1] || available[0]
      end
      hsh
    end
  end
end
