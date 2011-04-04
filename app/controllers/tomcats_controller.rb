class TomcatsController < ApplicationController
  def index
    @tomcats = Tomcat.all
  end
end
