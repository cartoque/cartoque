class Mainteneur < ActiveRecord::Base
  has_many :servers
  validates_presence_of :name

  default_scope order('name')

  def to_s
    name
  end
end
