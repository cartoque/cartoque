class BackupException
  include Mongoid::Document
  include Mongoid::Timestamps

  field :reason, type: String
  belongs_to :user
  has_and_belongs_to_many :servers
end
