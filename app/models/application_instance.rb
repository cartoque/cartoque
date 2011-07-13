class ApplicationInstance < ActiveRecord::Base
  belongs_to :application
  has_and_belongs_to_many :machines
  has_many :application_urls, :dependent => :destroy

  accepts_nested_attributes_for :application_urls, :reject_if => lambda{|a| a[:url].blank? },
                                                   :allow_destroy => true

  attr_accessible :name, :application_id, :machine_ids, :authentication_method, :application_urls_attributes,
                  :created_at, :updated_at

  AVAILABLE_AUTHENTICATION_METHODS = %w(none cerbere cerbere-cas cerbere-bouchon ldap-minequip internal other)

  validates_presence_of :name, :application_id, :authentication_method
  validates_inclusion_of :authentication_method, :in => AVAILABLE_AUTHENTICATION_METHODS

  def fullname
    "#{application.name} (#{name})"
  end
end
