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
    @nss_disks ||= end_of_association_chain.order_by([:server_name.asc, :name.asc])
  end

  def find_servers
    @servers = Server.where(:_id.in => NssDisk.all.distinct(:server_id)).order_by([:name.asc])
  end
end
