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

  include SortHelpers
  helper_method :sort_column, :sort_direction

  def collection
    @users ||= end_of_association_chain.order_by(mongo_sort_option)
  end
end
