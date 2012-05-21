class Datacenter
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  validates_presence_of :name
  validates_uniqueness_of :name

  class << self
    attr_accessor :default

    def default
      @default || first || create(name: "Datacenter")
    end
  end
end
