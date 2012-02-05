class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def cas
    auth = request.env["omniauth.auth"]
    @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if @user.present?
      sign_in_and_redirect @user, :event => :authentication
      #redirect_to root_url, :notice => "Hyperspace !"
    else
      redirect_to new_user_session_path :error => t(:omniauth_invalid_user)
    end
  end
end
