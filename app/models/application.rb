class Application < ActiveRecord::Base
  has_and_belongs_to_many :machines

  attr_accessible :name, :criticity, :info, :iaw, :pe, :moa, :amoa, :moa_note, :contact, :pnd, :ams,
                  :cerbere, :comment, :identifier, :machine_ids

  validates_presence_of :name

  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      scoped
    end
  end

  def self.find(*args)
    if args.first && args.first.is_a?(String) && !args.first.match(/^\d*$/)
      application = find_by_identifier(*args)
      raise ActiveRecord::RecordNotFound, "Couldn't find Application with identifier=#{args.first}" if application.nil?
      application
    else
      super
    end
  end
end
