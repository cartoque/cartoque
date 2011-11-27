class Company < ActiveRecord::Base
  has_many :users, :dependent => :nullify
  validates_presence_of :name

  def to_s
    name
  end
end
