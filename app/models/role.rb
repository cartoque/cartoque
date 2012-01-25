class Role < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  acts_as_list
  default_scope order('position')
end
