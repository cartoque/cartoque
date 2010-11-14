class Application < ActiveRecord::Base
  has_and_belongs_to_many :machines

  attr_accessible :nom, :criticite, :info, :iaw, :pe, :moa, :amoa, :moa_note, :contact, :pnd, :ams, :cerbere, :fiche

  validates_presence_of :nom
end
