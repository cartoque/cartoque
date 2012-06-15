class Tomcat
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Denormalize

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
  denormalize :name, from: :server

  #scopes
  scope :by_name, proc { |term| where(name: Regexp.mask(term)) }
  scope :by_vip, proc { |term| where(vip: Regexp.mask(term)) }
  scope :by_java_version, proc { |version| where(java_version: version) }
  scope :by_server_name, proc { |term| where(server_name: Regexp.mask(term)) }
end
