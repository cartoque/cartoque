class License < ActiveRecord::Base
  has_and_belongs_to_many :servers
end
