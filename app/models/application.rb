class Application < ActiveRecord::Base
  attr_accessible :nom, :criticite, :info, :iaw, :pe, :moa, :amoa, :moa_note, :contact, :pnd, :ams, :cerbere, :fiche
end
