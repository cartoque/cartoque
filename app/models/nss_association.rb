class NssAssociation < ActiveRecord::Base
  belongs_to :server
  belongs_to :nss_volume
end
