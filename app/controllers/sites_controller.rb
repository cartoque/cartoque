class SitesController < InheritedResources::Base
  layout "admin"

  before_filter :count_racks_per_site, :only => :index

  def create
    create! { sites_url }
  end

  def update
    update! { sites_url }
  end

  protected
  def count_racks_per_site
    @racks_count = PhysicalRack.group("site_id").count
    @servers_count = Server.where("virtual = ?", false).group("physical_racks.site_id").count
  end
end
