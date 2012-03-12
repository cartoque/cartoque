class BackupException
  include Mongoid::Document
  include Mongoid::Timestamps

  field :reason, type: String
  belongs_to :user

  #has_and_belongs_to_many :servers
  #TEMPORARY
  def server_ids
    ActiveRecord::Base.connection.execute("SELECT server_id FROM backup_exceptions_servers WHERE backup_exception_mongo_id='#{self.id}';").to_a.flatten
  end

  #TEMPORARY
  def servers
    Server.find(id: server_ids)
  end

  #TEMPORARY
  def server_ids=(*args)
    raise NotImplementedError, "should be implemented when Server is a Mongoid::Document"
  end
end
