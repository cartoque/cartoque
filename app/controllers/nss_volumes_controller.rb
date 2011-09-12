class NssVolumesController < InheritedResources::Base
  respond_to :html, :js
  actions :index, :show

  before_filter :find_servers

  has_scope :by_server

  protected
  def collection
    @nss_volumes ||= end_of_association_chain.joins(:server).order("servers.name asc, nss_volumes.name asc")
  end

  def find_servers
    @servers = Server.where(:id => NssVolume.select("distinct(server_id)").map(&:server_id)).order("name asc")
  end
end
