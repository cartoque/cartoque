require 'csv'

class ServersController < ResourcesController
  respond_to :html, :js, :xml, :csv, :json

  has_scope :by_location
  has_scope :by_maintainer
  has_scope :by_system
  has_scope :by_virtual
  has_scope :by_serial_number
  has_scope :by_arch
  has_scope :by_fullmodel

  before_filter :select_view_mode

  include SortHelpers

  def sort_column_prefix
    "servers."
  end
  helper_method :sort_column, :sort_direction, :sort_column_prefix

  def collection
    return @servers if defined?(@servers)
    @servers = end_of_association_chain.active.includes(:operating_system, :physical_rack).search(params[:search]).order(sort_option)
    if maintenance_mode?
      @servers = @servers.includes(maintainer: :contact_infos).where(virtual: false)
      if params[:sort] == "maintained_until"
        @servers = @servers.select{|m| m.maintained_until.present? } + @servers.select{|m| m.maintained_until.blank? }
      end
    end
    @servers = decorate_resource_or_collection(@servers)
  end

  private

  def select_view_mode
    current_user.update_setting(:servers_view_mode, params[:view_mode]) if params[:view_mode] && current_user
  end

  def maintenance_mode?
    current_user && current_user.settings[:servers_view_mode] == "maintenance"
  end
  helper_method :maintenance_mode?

  def view_mode
    maintenance_mode? ? "maintenance" : "normal"
  end
  helper_method :view_mode
end
