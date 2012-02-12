class Component
  include Mongoid::Document
  #key :name
  field :name, :type => String
  field :website, :type => String
  field :description, :type => String
end
