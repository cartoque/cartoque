class Datacenter
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  validates_presence_of :name
  validates_uniqueness_of :name

  class << self
    def default=(datacenter)
      Thread.current[:default_datacenter] = datacenter
    end

    def default
      Thread.current[:default_datacenter] || first || create(name: "Datacenter")
    end
  end
end
