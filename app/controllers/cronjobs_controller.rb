class CronjobsController < InheritedResources::Base
  respond_to :html, :js
  actions :index

  before_filter :find_servers

  has_scope :by_server

  def index
    @cronjobs = []
    @cronjobs = apply_scopes(Cronjob).all if params[:by_server].to_i > 0
  end

  protected
  def find_servers
    @servers = Server.where(:id => Cronjob.select("distinct(server_id)").map(&:server_id)).order("name asc")
  end
end
