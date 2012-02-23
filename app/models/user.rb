class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                  type: String
  field :uid,                   type: String
  field :provider,              type: String,  default: "internal"
  field :settings,              type: Hash,    default: {}
  field :authentication_token,  type: String
  field :email,                 type: String,  default: ""
  field :encrypted_password,    type: String,  default: ""
  field :sign_in_count,         type: Integer, default: 0
  field :current_sign_in_at,    type: DateTime
  field :last_sign_in_at,       type: DateTime
  field :current_sign_in_ip,    type: String
  field :last_sign_in_ip,       type: String

  # Some default modules are not included: :registerable, :recoverable, :validatable, :rememberable
  # Others available are: :encryptable, :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :trackable,
         :token_authenticatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  validates_presence_of :name
  validates_uniqueness_of :name

  def set_setting(key, value)
    h = settings.dup
    h.update(key => value)
    write_attribute(:settings, h)
    value
  end

  def update_setting(key, value)
    set_setting(key.to_s, value)
    save
  end

  def seen_on
    [self.last_sign_in_at, self.current_sign_in_at].compact.max
  end

  def locale
    settings["locale"] rescue nil
  end

  def locale=(new_locale)
    update_setting("locale", new_locale)
  end

  def datacenter
    @datacenter ||= Datacenter.default
  end
end
