class MediaDrive < ActiveRecord::Base
  has_many :servers

  default_scope order('name')

  def to_s
    name
  end
end
