class User < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :uid
  validates_presence_of :provider

  serialize :settings

  def settings
    read_attribute(:settings).presence || {}
  end

  def set_setting(key, value)
    h = settings.dup
    h.update(key => value)
    write_attribute(:settings, h)
    value
  end

  def update_setting(key, value)
    set_setting(key, value)
    save
  end
end
