class NssVolume
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :size, type: Integer
  field :snapshot_enabled, type: Boolean
  field :timemark_enabled, type: Boolean
  field :falconstor_id, type: Integer
  field :guid, type: String
  field :falcontstor_type, type: String
  field :dataset_guid, type: String
  field :server_name, type: String
  belongs_to :server, class_name: 'MongoServer'
  has_and_belongs_to_many :clients, class_name: 'MongoServer', foreign_key: 'client_ids'

  validates_presence_of :name

  before_save :cache_associations_fields

  scope :by_server, proc { |server_id| where(server_id: server_id) }
  scope :by_name, proc { |term| where(name: Regexp.new(term, Regexp::IGNORECASE)) }
  scope :by_client, proc { |client_id| any_in(client_ids: client_id) }
  scope :by_type, proc { |type| where(falconstor_type: type) }
  scope :by_guid, proc { |term| where(guid: Regexp.new(term, Regexp::IGNORECASE)) }
  scope :by_snapshot_status, proc { |status| where(snapshot_enabled: status) }

  private
  def cache_associations_fields
    self.server_name = self.server.try(:name)
  end
end
