class UpgradesController < ResourcesController
  respond_to :html, :js

  has_scope :by_package
  has_scope :by_server
  has_scope :by_any_package

  def validate
    @upgrade = Upgrade.find(params[:id]) rescue nil
    if @upgrade
      @upgrade.update_attribute(:upgrader_id, current_user.id)
      @upgrade.update_attribute(:upgraded_status, true)
    end
  end

  protected

  include SortHelpers
  helper_method :sort_column, :sort_direction, :sort_column_prefix

  def collection
    @upgrades ||= decorate_resource_or_collection(
                    end_of_association_chain.where(
                      :server_id.nin => UpgradeExclusion.only('server_ids').map(&:server_ids).flatten
                    ).order_by(mongo_sort_option)
                  )
  end
end
