class OperatingSystemsController < InheritedResources::Base
  layout "admin"

  def index
    @operating_systems = OperatingSystem.arrange(:order => "name")
  end

  def create
    create! { operating_systems_url }
  end

  def update
    update! { operating_systems_url }
  end
end
