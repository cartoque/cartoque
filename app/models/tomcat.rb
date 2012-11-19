class Tomcat
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Alize
  include ConfigurationItem

  #standard fields
  field :name, type: String
  field :vip, type: String
  field :dns, type: String
  field :directory, type: String
  field :tomcat_version, type: String
  field :java_version, type: String
  field :java_xms, type: String
  field :java_xmx, type: String
  field :jdbc_url, type: String
  field :jdbc_server, type: String
  field :jdbc_db, type: String
  field :jdbc_user, type: String
  field :jdbc_driver, type: String
  field :cerbere, type: Boolean       #TODO: remove it in favor of ApplicationInstance#authentication_method
  field :cerbere_csac, type: Boolean  #TODO: remove it in favor of ApplicationInstance#authentication_method
  #associations
  belongs_to :server #todo: inverse assoc
  has_and_belongs_to_many :cronjobs, autosave: true
  #denormalized
  alize :server, :name

  #scopes
  scope :by_name, proc { |term| where(name: Regexp.mask(term)) }
  scope :by_dns, proc { |term| where(dns: Regexp.mask(term)) }
  scope :by_java_version, proc { |term| where(java_version: Regexp.mask(term)) }
  scope :by_server_name, proc { |term| where(server_name: Regexp.mask(term)) }

  def server_name
    server_fields.try(:fetch, 'name') if server_id.present?
  end
end
