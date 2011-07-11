class ApplicationInstance < ActiveRecord::Base
  belongs_to :application
  has_and_belongs_to_many :machines

  def fullname
    "#{application.name} (#{name})"
  end
end
