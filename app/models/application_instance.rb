class ApplicationInstance < ActiveRecord::Base
  acts_as_configuration_item

  has_and_belongs_to_many :servers
  has_many :application_urls, dependent: :destroy

  accepts_nested_attributes_for :application_urls, reject_if: lambda{|a| a[:url].blank? },
                                                   allow_destroy: true

  attr_accessible :name, :application_mongo_id, :server_ids, :authentication_method, :application_urls_attributes,
                  :created_at, :updated_at

  #default_scope includes(:application).order("applications.name, application_instances.name")

  AVAILABLE_AUTHENTICATION_METHODS = %w(none cerbere cerbere-cas cerbere-bouchon ldap-minequip internal other)

  validates_presence_of :name, :authentication_method
  validates_inclusion_of :authentication_method, in: AVAILABLE_AUTHENTICATION_METHODS

  def fullname
    "#{application.name} (#{name})"
  end
  alias :to_s :fullname

  def application
    @application ||= Application.find(self.application_mongo_id)
  end
end
