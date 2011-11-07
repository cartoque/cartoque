class BackupExceptionsController < InheritedResources::Base
  before_filter :fill_user_id, :only => [:create, :update]
  def create
    create! { backup_exceptions_url }
  end

  def update
    update! { backup_exceptions_url }
  end

  protected
  def fill_user_id
    params[:backup_exception][:user_id] ||= current_user.id
  end
end
