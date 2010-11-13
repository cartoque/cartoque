class Site < ActiveRecord::Base
  has_many :machines
  
  default_scope order('nom')

  def to_s
    nom
  end
end
