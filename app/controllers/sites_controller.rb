class SitesController < InheritedResources::Base
  layout "admin"

  before_filter :count_racks_per_site, only: :index

  def create
    create! { sites_url }
  end

  def update
    update! { sites_url }
  end

  protected
  def count_racks_per_site
    @racks_count = PhysicalRack.only(:site_id).group_by(&:site_id)
                               .inject({}) { |memo,(k,v)| memo[k.to_s] = v.count; memo }
    @servers_count = Server.where(virtual: false).only(:site_id).group_by(&:site_id)
                           .inject({}) { |memo,(k,v)| memo[k.to_s] = v.count; memo }
  end
end
