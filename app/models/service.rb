class Service < ActiveRecord::Base
  has_many :machines

  def to_s
    nom
  end
end
