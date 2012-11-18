class ApplicationController < ActionController::Base
  before_filter :seek_authentication_token
  before_filter :authenticate_user!
  before_filter :set_format
  before_filter :set_locale
  around_filter :scope_current_user

  protect_from_forgery

  # Save user from seeing exceptions when trying to retrieve an undefined Mongoid object
  rescue_from Mongoid::Errors::DocumentNotFound, Moped::Errors::InvalidObjectId, with: :render_404
  def render_404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    respond_to do |format|
      format.html { render text: %(<div class="center not_found">These are not the droids you're looking for</div>),
                           status: :not_found, layout: true }
      format.any(:atom, :xml, :js, :json) { head :not_found }
    end
  end

  # This filter allows authentication from a custom http header
  private
  def seek_authentication_token
    params[:api_token] ||= env["HTTP_X_API_TOKEN"]
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

  # keeps good format accross request for API calls
  def set_format
    request.format = :json if params[:api_token].present? && params[:format].blank?
  end

  def scope_current_user
    User.current = current_user
    yield
  ensure
    User.current = nil
  end

  def extract_locale_from_accept_language_header
    "#{request.env['HTTP_ACCEPT_LANGUAGE']}".scan(/^[a-z]{2}/).first
  end

  #https://github.com/plataformatec/devise/wiki/How-To:-redirect-to-a-specific-page-on-successful-sign-in
  def after_sign_in_path_for(resource)
    #return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    #=> with our setup, omniauth.origin always contain sign_in page since user was first redirected on it
    return stored_location_for(resource) || root_path
  end
end
