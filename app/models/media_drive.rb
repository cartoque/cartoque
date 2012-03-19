class MediaDrive
  include Mongoid::Document

  field :name, type: String

  validates_presence_of :name

  def to_s
    name
  end
end
