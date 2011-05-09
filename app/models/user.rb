class User < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :uid
  validates_presence_of :provider
end
