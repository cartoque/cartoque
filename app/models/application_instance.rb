class ApplicationInstance
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :authentication_method, type: String
  embeds_many :application_urls
  belongs_to :application

  accepts_nested_attributes_for :application_urls, reject_if: lambda{|a| a[:url].blank? },
                                                   allow_destroy: true

  attr_accessible :name, :application_id, :server_ids, :authentication_method, :application_urls_attributes,
                  :created_at, :updated_at

  #TODO: restablish CI callbacks
  #acts_as_configuration_item

  #default_scope includes(:application).order("applications.name, application_instances.name")

  AVAILABLE_AUTHENTICATION_METHODS = %w(none cerbere cerbere-cas cerbere-bouchon ldap-minequip internal other)

  validates_presence_of :name, :authentication_method
  validates_inclusion_of :authentication_method, in: AVAILABLE_AUTHENTICATION_METHODS

  def server_ids
    @server_ids ||= ActiveRecord::Base.connection.execute(
      "SELECT server_id FROM application_instances_servers WHERE application_instance_mongo_id = '#{self.id}';"
    ).to_a.flatten
  end

  def servers
    @servers ||= Server.find(server_ids)
  end

  def fullname
    "#{application.name} (#{name})"
  end
  alias :to_s :fullname

  def application
    @application ||= Application.find(self.application_mongo_id)
  end
end
