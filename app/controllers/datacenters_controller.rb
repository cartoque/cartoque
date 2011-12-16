class DatacentersController < InheritedResources::Base
  layout 'admin'

  def create
    create! { datacenters_url }
  end

  def update
    update! { datacenters_url }
  end
end
