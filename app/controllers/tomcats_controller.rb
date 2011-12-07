require 'csv'

class TomcatsController < ApplicationController
  respond_to :html, :js, :csv

  def index
    @tomcats = Tomcat.all
    @filters = Tomcat.filters_from(@tomcats)
    @tomcats = Tomcat.filter_collection(@tomcats, params)
  end

  def index_old
    @tomcats_old = TomcatOld.all
    @filters = TomcatOld.filters_from(@tomcats_old)
    #restrict tomcats
    @tomcats_old = @tomcats_old.select{|t| t[:server] == params[:by_server]} if params[:by_server].present?
    @tomcats_old = @tomcats_old.select{|t| t[:tomcat].starts_with?(params[:by_tomcat]) } if params[:by_tomcat].present?
  end
end
