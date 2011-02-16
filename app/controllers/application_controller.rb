class ApplicationController < ActionController::Base
  protect_from_forgery

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
end
