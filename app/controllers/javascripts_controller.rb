class JavascriptsController < ApplicationController
  respond_to :js

  def hide_announcement
    current_user.settings[:announcement_hide_time] = Time.now
    current_user.save
  end
end
