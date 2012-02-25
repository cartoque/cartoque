class ApplicationUrl
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :public, type: Boolean
  embedded_in :application_instance

  validates_presence_of :url
  validates_presence_of :application_instance
end
