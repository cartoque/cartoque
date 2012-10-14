class Role
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :position, type: Integer
  
  def initialize(*args)
    super
    if self.position.blank?
      max_role = Role.order_by(:position.asc).last.try(:position) || 0
      self.position = max_role + 1
    end
  end

  validates_presence_of :name
  validates_uniqueness_of :name

  default_scope order_by(:position.asc)
end
