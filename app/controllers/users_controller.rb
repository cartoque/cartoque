class UsersController < InheritedResources::Base
  layout "admin"

  def create
    create! { users_url }
  end

  def update
    update! { users_url }
  end

  def random_token
    @token = SecureRandom.hex(16)
  end
end
