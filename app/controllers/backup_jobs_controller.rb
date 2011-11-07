class BackupJobsController < InheritedResources::Base
  respond_to :html, :js
  actions :index

  has_scope :by_server

  before_filter :find_filters, :only => :index
  before_filter :find_not_backuped, :only => :index
  
  protected
  def collection
    @backup_jobs ||= end_of_association_chain.includes(:server).where("servers.status" => Server::STATUS_ACTIVE).order("servers.name asc")
  end

  def find_filters
    @servers = Server.find( BackupJob.select("distinct(server_id)").map(&:server_id) ).select(&:active?).sort_by(&:name)
  end

  def find_not_backuped
    @not_backuped = Server.not_backuped
  end
end
