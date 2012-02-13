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
      Role.update_all(['position=?', index+1], ['id=?', id])
    end 
    render nothing: true
  end
end
