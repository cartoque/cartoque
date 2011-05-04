class SitesController < InheritedResources::Base
  layout "admin"

  def create
    create! { sites_url }
  end

  def update
    update! { sites_url }
  end
end
