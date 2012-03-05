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
      Role.where(_id: id).update_all(position: index+1)
    end 
    render nothing: true
  end
end
