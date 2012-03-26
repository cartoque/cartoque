class CronjobsController < InheritedResources::Base
  respond_to :html, :js
  actions :index

  before_filter :find_servers

  has_scope :by_server
  has_scope :by_command
  has_scope :by_definition

  include SortHelpers
  helper_method :sort_column, :sort_direction

  def index
    @cronjobs = []
    if (params[:by_server].to_i > 0) || params[:by_command].present? || params[:by_definition].present?
      @cronjobs = apply_scopes(Cronjob).order_by(mongo_sort_option).limit(100)
    end
  end

  protected
  def find_servers
    @servers = Server.where(:_id.in => Cronjob.all.distinct("server_id")).order_by([:name.asc])
  end
end
