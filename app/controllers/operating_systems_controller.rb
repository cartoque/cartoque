class OperatingSystemsController < InheritedResources::Base
  layout "admin"

  def index
    @operating_systems = OperatingSystem.arrange(order: "name")
    @os_servers_count = Server.group("operating_system_id").count
    @os_servers_count.default = 0
    if params[:graph_subtree]
      @root_os = OperatingSystem.find(params[:graph_subtree].to_i)
      @os_subtree = @root_os.descendants.arrange(order: :name) if @root_os.present?
    else
      @os_subtree = @operating_systems
    end
    @last_updated_server = Server.maximum(:updated_at)
  end

  def create
    create! { operating_systems_url }
  end

  def update
    update! { operating_systems_url }
  end
end
