class Theme < ActiveRecord::Base
  has_many :machines

  default_scope order('titre')

  def to_s
    titre
  end
end
