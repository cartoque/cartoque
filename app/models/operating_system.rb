class OperatingSystem
  include Mongoid::Document
  include Mongoid::Ancestry
  include Mongoid::Timestamps

  field :name, type: String
  field :codename, type: String
  field :managed_with_puppet, type: Boolean
  has_ancestry cache_depth: true

  validates_presence_of :name

  #TEMPORARY METHODS
  def server_ids
    ActiveRecord::Base.connection.execute(
      "SELECT id FROM servers WHERE operating_system_mongo_id = '#{self.id}';"
    ).to_a.flatten
  end

  #TEMPORARY
  def servers
    Server.find(server_ids)
  end

  #doesn't work with Ancestry (see: https://github.com/stefankroes/ancestry/issues/42)
  #default_scope order('name')

  def to_s
    name + (codename.present? ? " "+codename : "")
  end
end
