class Datacenter
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.default
    Datacenter.first || Datacenter.create(name: "Datacenter")
  end
end
