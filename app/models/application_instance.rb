class ApplicationInstance < ActiveRecord::Base
  belongs_to :application
  has_and_belongs_to_many :machines
  has_many :application_urls, :dependent => :destroy

  accepts_nested_attributes_for :application_urls, :reject_if => lambda{|a| a[:url].blank? },
                                                   :allow_destroy => true

  attr_accessible :name, :application_id, :machine_ids, :application_urls_attributes

  def fullname
    "#{application.name} (#{name})"
  end
end
