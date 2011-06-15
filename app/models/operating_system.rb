class OperatingSystem < ActiveRecord::Base
  has_many :machines
  has_ancestry :cache_depth => true

  #doesn't work with Ancestry (see: https://github.com/stefankroes/ancestry/issues/42)
  #default_scope order('name')

  def to_s
    name
  end
end
