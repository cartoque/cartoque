class DatabasesController < InheritedResources::Base
  before_filter :select_view_mode

  def create
    create! { databases_url }
  end

  def update
    update! { databases_url }
  end

  private

  def select_view_mode
    session[:databases_view_mode] = params[:view_mode] if params[:view_mode]
  end

  def databases_view_mode
    if action_name == "show" || request_from_pdfkit?
      "detailed"
    else
      session[:databases_view_mode] || "normal"
    end
  end
  helper_method :databases_view_mode
end
