class ApplicationController < ActionController::Base
  before_filter :authenticate!

  protect_from_forgery

  helper_method :current_user, :logged_in?

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
  def authenticate!
    redirect_to("/auth/required") unless logged_in?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end
end
