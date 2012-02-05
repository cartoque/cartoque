class ApplicationController < ActionController::Base
  before_filter :seek_authentication_token
  before_filter :authenticate_user!
  before_filter :set_locale

  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404 exception
  end

  def render_404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    respond_to do |format|
      format.html { render :text => %(<div class="center not_found">These are not the droids you're looking for</div>),
                           :status => :not_found, :layout => true }
      format.any(:atom, :xml, :js, :json) { head :not_found }
    end
  end

  private
  def authenticate!
    redirect_to("/auth/required") unless logged_in?
  end

  def zcurrent_user
    return @current_user if @current_user
    # Standard login
    if valid_session_user_id?
      @current_user = User.find_by_id(session_user_id)
    # API login
    elsif valid_api_token? && api_request?
      @current_user = User.find_by_authentication_token(token)
    end
    # update User#seen_on if possible
    @current_user.try(:seen_now!)
    @current_user
  end
  #helper_method :current_user

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  def api_request?
    %w(csv json xml).include?(params[:format])
  end

  def valid_session_user_id?
    session_user_id && session_user_id.to_i > 0
  end

  def session_user_id
    session[:user_id]
  end

  def valid_api_token?
    token && token.length > 5
  end

  def token
    env["HTTP_X_API_TOKEN"]
  end

  # This filter allows authentication from a custom http header
  def seek_authentication_token
    params[:api_token] ||= token
  end

  #for more information on pdfkit + asset pipeline:
  #http://www.mobalean.com/blog/2011/08/02/pdf-generation-and-heroku
  def request_from_pdfkit?
    request.env["Rack-Middleware-PDFKit"] == "true"
  end
  helper_method :request_from_pdfkit?

  # locale selection
  # see: http://guides.rubyonrails.org/i18n.html
  def set_locale
    #logger.debug "* Current user: #{current_user.inspect}"
    #logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    locale_candidate = current_user.try(:locale).presence
    locale_candidate ||= extract_locale_from_accept_language_header
    if locale_candidate && I18n.available_locales.include?(locale_candidate.to_sym)
      I18n.locale = locale_candidate
    end
    #logger.debug "* Locale set to '#{I18n.locale}'"
  end

  private
  def extract_locale_from_accept_language_header
    "#{request.env['HTTP_ACCEPT_LANGUAGE']}".scan(/^[a-z]{2}/).first
  end
end
