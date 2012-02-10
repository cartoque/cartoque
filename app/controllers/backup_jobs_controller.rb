class BackupJobsController < InheritedResources::Base
  respond_to :html, :js
  actions :index

  has_scope :by_server
  has_scope :by_client_type

  before_filter :find_not_backuped, :only => :index
  
  protected
  def collection
    @backup_jobs ||= end_of_association_chain.includes(:server).where("servers.status" => Server::STATUS_ACTIVE).order("servers.name asc")
  end

  def find_not_backuped
    not_backuped = Server.not_backuped
    @not_backuped_count = not_backuped.count
    @virtual_not_backuped, @physical_not_backuped = not_backuped.partition{|s| s.virtual?}
  end
end
