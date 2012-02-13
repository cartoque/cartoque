class Database < ActiveRecord::Base
  acts_as_configuration_item

  attr_accessible :name, :database_type, :server_ids

  has_many :database_instances, dependent: :destroy
  has_many :servers

  validates_presence_of :name
  validates_inclusion_of :database_type, in: %w(postgres oracle)

  scope :by_name, proc {|name| where("databases.name LIKE ?", "%#{name}%") }
  scope :by_type, proc {|type| { conditions: { database_type: type } } }

  def to_s
    name
  end

  def postgres_report
    servers.inject([]) do |memo,server|
      memo.concat(server.postgres_report)
    end.sort_by do |report|
      [report["port"].to_i, report["pg_cluster"]]
    end
  end

  def oracle_report
    servers.inject([]) do |memo,server|
      memo.concat(server.oracle_report)
    end.sort_by do |report|
      report["ora_instance"]
    end
  end

  def report
    method = :"#{database_type}_report"
    respond_to?(method) ? send(method) : []
  end

  def instances
    report.size
  end

  def size
    case database_type
    when "postgres"
      report.inject(0) do |memo,instance|
        memo += instance["databases"].values.sum
      end
    when "oracle"
      report.inject(0) do |memo,instance|
        memo += instance["schemas"].values.sum
      end
    else
      0
    end
  end
end
