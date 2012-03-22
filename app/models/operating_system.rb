class OperatingSystem
  include Mongoid::Document
  include Mongoid::Ancestry
  include Mongoid::Timestamps

  field :name, type: String
  field :codename, type: String
  field :managed_with_puppet, type: Boolean
  has_ancestry cache_depth: true
  has_many :servers, class_name: 'MongoServer'

  validates_presence_of :name

  #doesn't work with Ancestry (see: https://github.com/stefankroes/ancestry/issues/42)
  #default_scope order('name')

  def to_s
    name + (codename.present? ? " "+codename : "")
  end
end
