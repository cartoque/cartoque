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
    @racks_count = PhysicalRack.only(:site_id).inject(Hash.new(0)) do |memo,rack|
      memo[rack.site_id] += 1
      memo
    end
    @servers_count = Server.where("virtual = ?", false).group("site_mongo_id").count
  end
end
