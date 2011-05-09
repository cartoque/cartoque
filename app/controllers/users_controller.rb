class UsersController < InheritedResources::Base
  layout "admin"

  def create
    create! { users_url }
  end

  def update
    update! { users_url }
  end
end
