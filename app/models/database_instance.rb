class DatabaseInstance
  include Mongoid::Document
  include Mongoid::Timestamps
  include ConfigurationItem

  field :name, type: String
  field :listen_address, type: String
  field :listen_port, type: Integer
  field :host_alias, type: String
  field :version, type: String
  field :databases, type: Hash, default: {}
  field :config, type: Hash, default: {}
  belongs_to :database

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:database_id, :listen_address, :listen_port]
  validate :databases_cant_be_nil

  def databases_cant_be_nil
    errors.add(:databases, "can't be nil") if databases.nil?
  end

  def size
    databases.values.sum
  end
end
