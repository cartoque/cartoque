class PhysicalRacksController < InheritedResources::Base
  layout "admin"

  before_filter :count_machines_per_rack, :only => :index

  def create
    create! { physical_racks_url }
  end

  def update
    update! { physical_racks_url }
  end

  protected
  def count_machines_per_rack
    @machines_count = Machine.where("virtual = ?", false).group("physical_rack_id").count
  end
end
