class UpgradeExclusionsController < InheritedResources::Base
  before_filter :fill_user_id, only: [:create, :update]

  def create
    create! { upgrade_exclusions_url }
  end

  def update
    update! { upgrade_exclusions_url }
  end

  protected
  def fill_user_id
    params[:upgrade_exclusion][:user_id] ||= current_user.id
  end
end
