class JavascriptsController < ApplicationController
  respond_to :js

  def hide_announcement
    session[:announcement_hide_time] = Time.now
  end
end
