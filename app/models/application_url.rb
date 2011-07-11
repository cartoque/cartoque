class ApplicationUrl < ActiveRecord::Base
  belongs_to :application

  validates_presence_of :url
end
