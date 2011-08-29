class OperatingSystemsController < InheritedResources::Base
  layout "admin"

  def index
    @operating_systems = OperatingSystem.arrange(:order => "name")
    @os_servers_count = Server.group("operating_system_id").count
    @os_servers_count.default = 0
  end

  def create
    create! { operating_systems_url }
  end

  def update
    update! { operating_systems_url }
  end
end
