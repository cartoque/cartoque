class User < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :uid
  validates_presence_of :provider

  serialize :settings

  def settings
    read_attribute(:settings).presence || {}
  end
end
