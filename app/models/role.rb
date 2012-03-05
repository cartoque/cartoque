class Role
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :position, type: Integer, default: -> { Role.max(:position).to_i + 1 }

  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  default_scope order_by(:position.asc)
end
