class ApplicationController < ActionController::Base
  before_filter :seek_authentication_token
  before_filter :authenticate_user!
  before_filter :set_locale
  before_filter :set_datacenter

  protect_from_forgery

  # Save user from seeing exceptions when trying to retrieve an undefined Mongoid object
  rescue_from Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId, with: :render_404
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

  def extract_locale_from_accept_language_header
    "#{request.env['HTTP_ACCEPT_LANGUAGE']}".scan(/^[a-z]{2}/).first
  end

  def set_datacenter
    if current_user && current_user.preferred_datacenter.present?
      Datacenter.default = current_user.preferred_datacenter
    end
  end
end
