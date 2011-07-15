class ApplicationUrl < ActiveRecord::Base
  belongs_to :application_instance

  validates_presence_of :url
end
