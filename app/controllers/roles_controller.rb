class RolesController < InheritedResources::Base
  layout 'admin'

  def create
    create! { roles_path }
  end

  def update
    update! { roles_path }
  end

  def sort
    params[:role].each_with_index do |id, index|
      role = Role.find(id)
      role.position = index+1
      role.save
    end 
    render nothing: true
  end
end
