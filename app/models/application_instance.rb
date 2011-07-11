class ApplicationInstance < ActiveRecord::Base
  belongs_to :application
  has_and_belongs_to_many :machines
end
