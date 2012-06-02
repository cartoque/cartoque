class ServerExtension
  include Mongoid::Document

  #standard fields
  field :name, :type => String
  field :serial_number, :type => String
  #associations
  belongs_to :server

  validates_uniqueness_of :name, scope: :server_id
end
