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
    @nss_volumes ||= end_of_association_chain.order_by([:server_name.asc, :name.asc])
  end

  def find_servers_and_clients
    @servers = MongoServer.where(id: NssVolume.all.distinct(:server_id)).order_by([:name.asc])
    @clients = MongoServer.where(id: NssVolume.all.distinct(:client_ids).flatten.uniq).order_by([:name.asc])
  end
end
