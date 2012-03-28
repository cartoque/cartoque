class Database
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :type, type: String
  has_many :servers

  validates_presence_of :name
  validates_inclusion_of :type, in: %w(postgres oracle)

  scope :by_name, proc { |term| where(name: Regexp.mask(term)) }
  scope :by_type, proc { |term| where(type: term) }

  #TODO: see why Mongoid doesn't generate that for us
  def server_ids=(ids)
    actual_ids = self.servers.map(&:_id).map(&:to_s)
    new_ids = ids.map(&:to_s)
    #deletions
    self.servers -= Server.where(:_id.in => actual_ids - new_ids).to_a
    #additions
    self.servers << Server.where(:_id.in => new_ids - actual_ids).to_a
  end

  #TODO: see why Mongoid doesn't generate that for us
  def server_ids
    self.servers.map(&:_id)
  end

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
    method = :"#{type}_report"
    respond_to?(method) ? send(method) : []
  end

  def instances
    report.size
  end

  def size
    case type
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
