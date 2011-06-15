class TomcatsController < ApplicationController
  respond_to :html, :js

  def index
    @tomcats = Tomcat.all
    #filters options
    @filters = {}
    @tomcats.each do |tomcat|
      tomcat.each do |key,value|
        @filters[key] ||= []
        value = value.split("_").first if key == :tomcat
        @filters[key] << value unless @filters[key].include?(value)
        @filters[key] = @filters[key].compact.sort
      end
    end
    #restrict tomcats
    @tomcats = @tomcats.select{|t| t[:server] == params[:by_server]} if params[:by_server].present?
    @tomcats = @tomcats.select{|t| t[:tomcat].starts_with?(params[:by_tomcat]) } if params[:by_tomcat].present?
  end
end
