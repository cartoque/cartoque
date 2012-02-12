class User < ActiveRecord::Base
  # Some default modules are not included: :registerable, :recoverable, :validatable
  # Others available are: :encryptable, :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :rememberable, :trackable,
         :token_authenticatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  validates_presence_of :name
  validates_uniqueness_of :name

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

  def seen_on
    [self.last_sign_in_at, self.current_sign_in_at].compact.max
  end

  def locale
    settings[:locale] rescue nil
  end

  def locale=(new_locale)
    update_setting(:locale, new_locale)
  end

  def datacenter
    @datacenter ||= Datacenter.default
  end
end
