require 'd3_utils'

class Database
  include Mongoid::Document
  include Mongoid::Timestamps
  include ConfigurationItem

  field :name, type: String
  field :type, type: String
  has_many :servers, autosave: true #mandatory with forms
  has_many :database_instances, dependent: :destroy

  validates_presence_of :name
  validates_inclusion_of :type, in: %w(postgres oracle)

  scope :by_name, proc { |term| where(name: Regexp.mask(term)) }
  scope :by_type, proc { |term| where(type: term) }

  #TODO: see why Mongoid doesn't generate that for us
  def server_ids=(ids)
    self.servers = Server.where(:_id.in => ids)
  end

  #TODO: see why Mongoid doesn't generate that for us
  def server_ids
    self.servers.map(&:_id)
  end

  def to_s
    name
  end

  def instances
    raise "Shouldn't be used, not explicit method name"
    report.size
  end

  def size
    database_instances.map(&:size).sum
  end

  def self.hash_distribution(dbs = Database.includes(:servers))
    map = {"oracle" => {}, "postgres" => {}}
    dbs.each do |db|
      dbmap = {}
      db.database_instances.each do |db_instance|
        name = db_instance.name
        subdbs = db_instance.databases
        if name.present? && subdbs.present?
          dbmap[name] = subdbs
        end
      end
      map[db.type][db.name] = dbmap
    end
    { databases: map }
  end

  def self.d3_distribution(*args)
    D3Utils.hash_to_d3format(self.hash_distribution(*args)).first
  end
end
