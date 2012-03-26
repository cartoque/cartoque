class UpgradesController < InheritedResources::Base
  respond_to :html, :js

  has_scope :by_package
  has_scope :by_server

  def validate
    @upgrade = Upgrade.find_by_id(params[:id])
    if @upgrade
      @upgrade.update_attribute(:upgrader_id, current_user.id)
      @upgrade.update_attribute(:upgraded_status, true)
    end
  end

  protected

  include SortHelpers
  helper_method :sort_column, :sort_direction, :sort_column_prefix

  def collection
    @upgrades ||= end_of_association_chain.order_by(mongo_sort_option)
  end
end
