class TomcatsController < ApplicationController
  respond_to :html, :js

  def index
    @tomcats = Tomcat.all
    @filters = Tomcat.filters_from(@tomcats)
    @tomcats = @tomcats.select{|t| t[:vip].starts_with?(params[:by_vip]) } if params[:by_vip].present?
    @tomcats = @tomcats.select{|t| t[:server] == params[:by_server]} if params[:by_server].present?
    @tomcats = @tomcats.select{|t| t[:tomcat].starts_with?(params[:by_tomcat]) } if params[:by_tomcat].present?
    @tomcats = @tomcats.select{|t| t[:java_version].starts_with?(params[:by_java]) } if params[:by_java].present?
  end

  def index_old
    @tomcats_old = TomcatOld.all
    @filters = TomcatOld.filters_from(@tomcats_old)
    #restrict tomcats
    @tomcats_old = @tomcats_old.select{|t| t[:server] == params[:by_server]} if params[:by_server].present?
    @tomcats_old = @tomcats_old.select{|t| t[:tomcat].starts_with?(params[:by_tomcat]) } if params[:by_tomcat].present?
  end
end
