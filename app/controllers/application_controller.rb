class ApplicationController < ActionController::Base
  before_filter :authenticate!

  protect_from_forgery

  helper_method :current_user, :logged_in?

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404 exception
  end

  def render_404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    respond_to do |format|
      format.html { render :text => %(<div class="center not_found">These are not the droids you're looking for</div>),
                           :status => :not_found, :layout => true }
      format.atom { head :not_found }
      format.xml { head :not_found }
      format.js { head :not_found }
      format.json { head :not_found }
    end
  end

  private
  def authenticate!
    redirect_to("/auth/required") unless logged_in? || api_request?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def api_request?
    request.local? && %w(json xml).include?(params[:format])
  end
end
