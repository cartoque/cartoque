require 'csv'

class TomcatsController < ResourcesController
  respond_to :html, :js, :csv

  has_scope :by_name
  has_scope :by_vip
  has_scope :by_java_version
  has_scope :by_server_name

  def index_old
    @tomcats_old = TomcatOld.all
    @filters = TomcatOld.filters_from(@tomcats_old)
    #restrict tomcats
    @tomcats_old = @tomcats_old.select{|t| t[:server] == params[:by_server]} if params[:by_server].present?
    @tomcats_old = @tomcats_old.select{|t| t[:tomcat].starts_with?(params[:by_tomcat]) } if params[:by_tomcat].present?
  end

  def collection
    @tomcats ||= end_of_association_chain.order_by(:name.asc)
  end
end
