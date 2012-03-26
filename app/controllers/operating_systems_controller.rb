class OperatingSystemsController < InheritedResources::Base
  layout "admin"

  def index
    @operating_systems = OperatingSystem.arrange(order: [:name, :asc])
    @os_servers_count = MongoServer.all.group_by(&:operating_system_id)
                                   .inject({}) { |memo,(k,v)| memo[k] = v.count; memo }
    @os_servers_count.default = 0
    if params[:graph_subtree]
      @root_os = OperatingSystem.find(params[:graph_subtree].to_s)
      @os_subtree = @root_os.descendants.arrange(order: [:name, :asc]) if @root_os.present?
    else
      @os_subtree = @operating_systems
    end
    @last_updated_server = MongoServer.order_by(:updated_at.desc).first
    @last_updated_system = OperatingSystem.order_by(:updated_at.desc).first
  end

  def create
    create! { operating_systems_url }
  end

  def update
    update! { operating_systems_url }
  end
end
