class NssVolumesController < InheritedResources::Base
  respond_to :html, :js
  actions :index, :show

  before_filter :find_servers_and_clients

  has_scope :by_server
  has_scope :by_name
  has_scope :by_client
  has_scope :by_type
  has_scope :by_guid
  has_scope :by_snapshot_status

  protected
  def collection
    @nss_volumes ||= end_of_association_chain.joins(:server).includes(:clients).order("servers.name asc, nss_volumes.name asc")
  end

  def find_servers_and_clients
    @servers = Server.where(:id => NssVolume.select("distinct(server_id)").map(&:server_id)).order("name asc")
    @clients = Server.where(:id => NssAssociation.select("distinct(server_id)").map(&:server_id)).order("name asc")
  end
end
