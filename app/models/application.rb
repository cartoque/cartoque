class Application < ActiveRecord::Base
  has_and_belongs_to_many :machines
  has_many :application_instances, :dependent => :destroy
  accepts_nested_attributes_for :application_instances, :reject_if => lambda{|a| a[:name].blank? },
                                                        :allow_destroy => true

  attr_accessible :name, :criticity, :info, :iaw, :pe, :moa, :amoa, :moa_note, :contact, :pnd, :ams,
                  :cerbere, :comment, :identifier, :machine_ids, :application_instances_attributes

  validates_presence_of :name

  before_save :update_cerbere_from_instances

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

  def update_cerbere_from_instances
    self.cerbere = self.application_instances.inject(false) do |memo,app_instance|
      memo || app_instance.authentication_method == "cerbere"
    end
    true
  end
end
