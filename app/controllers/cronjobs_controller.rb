class CronjobsController < InheritedResources::Base
  respond_to :html, :js
  actions :index

  before_filter :find_servers

  has_scope :by_server
  has_scope :by_command
  has_scope :by_definition

  def index
    @cronjobs = []
    if (params[:by_server].to_i > 0) || params[:by_command].present? || params[:by_definition].present?
      @cronjobs = apply_scopes(Cronjob).first(100)
    end
  end

  protected
  def find_servers
    @servers = Server.where(:id => Cronjob.select("distinct(server_id)").map(&:server_id)).order("name asc")
  end
end
