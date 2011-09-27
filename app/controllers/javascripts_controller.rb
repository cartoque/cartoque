class JavascriptsController < ApplicationController
  respond_to :js

  def hide_announcement
    current_user.update_setting :announcement_hide_time, Time.now
  end
end
