class PhysicalRacksController < InheritedResources::Base
  layout "admin"

  before_filter :count_servers_per_rack, :only => :index

  def create
    create! { physical_racks_url }
  end

  def update
    update! { physical_racks_url }
  end

  protected
  def collection
    @physical_racks ||= end_of_association_chain.except(:order).order('physical_racks.status, sites.name, physical_racks.name')
  end

  def count_servers_per_rack
    @servers_count = Server.where("virtual = ?", false).group("physical_rack_id").count
  end
end
