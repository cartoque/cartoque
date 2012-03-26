class BackupJob
  include Mongoid::Document
  include Mongoid::Timestamps

  field :hierarchy, type: String
  field :client_type, type: String
  field :catalog, type: String
  field :exclusion_patterns, type: String
  field :server_name, type: String
  field :server_status, type: Integer
  belongs_to :server

  scope :by_server, proc{ |term| includes(:server).where(server_name: Regexp.new(term, Regexp::IGNORECASE)) }
  scope :by_client_type, proc{ |client_type| where(client_type: client_type) }

  validates_presence_of :server, :hierarchy

  before_save :cache_server_name
  before_save :cache_server_status

  protected
  def cache_server_name
    self.server_name = self.server.try(:name)
  end

  def cache_server_status
    self.server_status = self.server.try(:status)
  end
end
