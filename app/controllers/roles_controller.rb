class RolesController < InheritedResources::Base
  layout 'admin'

  def create
    create! { roles_path }
  end

  def update
    update! { roles_path }
  end
end
