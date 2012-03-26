class NssDisk
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :server_name, type: String
  field :wwid, type: String
  field :falconstor_type, type: String
  field :owner, type: String
  field :category, type: String
  field :guid, type: String
  field :fsid, type: String
  field :size, type: Integer
  belongs_to :server

  before_save :cache_associations_fields

  validates_presence_of :server, :name

  scope :by_server, proc { |server_id| where(server_id: server_id) }
  scope :by_owner, proc { |owner| where(owner: owner) }
  scope :by_name, proc { |term| where(name: Regexp.new(term, Regexp::IGNORECASE)) }
  scope :by_type, proc { |type| where(falconstor_type: type) }
  scope :by_guid, proc { |term| where(guid: Regexp.new(term, Regexp::IGNORECASE)) }

  private
  def cache_associations_fields
    self.server_name = self.server.try(:name)
  end
end
