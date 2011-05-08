class PhysicalRacksController < InheritedResources::Base
  layout "admin"

  def create
    create! { physical_racks_url }
  end

  def update
    update! { physical_racks_url }
  end
end
