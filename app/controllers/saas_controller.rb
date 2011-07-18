class SaasController < ApplicationController
  def show
    render "#{params[:id]}".parameterize
  rescue ActionView::MissingTemplate
    render_404
  end
end
