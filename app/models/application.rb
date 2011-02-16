class Application < ActiveRecord::Base
  has_and_belongs_to_many :machines

  attr_accessible :nom, :criticite, :info, :iaw, :pe, :moa, :amoa, :moa_note, :contact, :pnd, :ams, :cerbere, :fiche

  validates_presence_of :nom

  def self.search(search)
    if search
      where("nom LIKE ?", "%#{search}%")
    else
      scoped
    end
  end

  def self.find(*args)
    if args.first && args.first.is_a?(String) && !args.first.match(/^\d*$/)
      application = find_by_nom(*args)
      raise ActiveRecord::RecordNotFound, "Couldn't find Application with identifier=#{args.first}" if application.nil?
      application
    else
      super
    end
  end
end
