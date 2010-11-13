class Service < ActiveRecord::Base
  belongs_to :machine

  def to_s
    nom
  end
end
