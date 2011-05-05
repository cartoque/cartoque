class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if user.blank?
      redirect_to auth_failure_url(:message => "invalid_user")
    else
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Hyperspace !"
    end
  end

  def failure
    flash[:error] = t(:"omniauth_#{params[:message].gsub(%r(/.*),"")}")
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Au revoir"
  end
end
