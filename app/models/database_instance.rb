class DatabaseInstance < ActiveRecord::Base
  belongs_to :database

  validates_presence_of :database
end
