class ApplicationUrl < ActiveRecord::Base
  belongs_to :application_instance

  validates_presence_of :url

  scope :public, where(public: true)
  scope :private, where(public: false)
end
