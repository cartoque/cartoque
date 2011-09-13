class NssDisksController < InheritedResources::Base
  respond_to :html, :js
  actions :index

  before_filter :find_servers

  has_scope :by_server
  has_scope :by_owner
  has_scope :by_name
  has_scope :by_type
  has_scope :by_guid

  protected
  def collection
    @nss_disks ||= end_of_association_chain.joins(:server).order("servers.name asc, nss_disks.name asc")
  end

  def find_servers
    @servers = Server.where(:id => NssDisk.select("distinct(server_id)").map(&:server_id)).order("name asc")
  end
end
