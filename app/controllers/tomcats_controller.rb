class TomcatsController < ApplicationController
  respond_to :html, :js

  def index
    @tomcats = Tomcat.all
    @filters = {}
    @tomcats.each do |tomcat|
      tomcat.each do |key,value|
        @filters[key] ||= []
        @filters[key] << value unless @filters[key].include?(value)
        @filters[key] = @filters[key].compact.sort
      end
    end
    @tomcats = @tomcats.select{|t| t[:server] == params[:by_server]} if params[:by_server].present?
  end
end
