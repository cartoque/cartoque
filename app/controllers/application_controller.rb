class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound do |exception|
    status = 404
    respond_to do |format|
      format.html { render :text => "These are not the droids you're looking for", :status => status }
      format.atom { head status }
      format.xml { head status }
      format.js { head status }
      format.json { head status }
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
