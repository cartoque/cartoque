#taken from: https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec)
module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in Factory.create(:admin) # Using factory girl as an example
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = Factory.create(:user)
      #we don't use :confirmable module for now, so the following line is useless
      # user.confirm!  #or set a confirmed_at inside the factory.
      sign_in user
    end
  end
end
