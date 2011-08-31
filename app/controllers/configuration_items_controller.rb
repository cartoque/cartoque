class ConfigurationItemsController < InheritedResources::Base
  actions :index, :show
  
  respond_to :html, :js

  has_scope :by_item_type
end
