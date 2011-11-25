class OperatingSystem < ActiveRecord::Base
  has_many :servers
  has_ancestry :cache_depth => true

  validates_presence_of :name

  #doesn't work with Ancestry (see: https://github.com/stefankroes/ancestry/issues/42)
  #default_scope order('name')

  def to_s
    name + (codename.present? ? " "+codename : "")
  end
end
