require 'csv'

class MachinesController < InheritedResources::Base
  include SortHelpers

  respond_to :html, :js, :xml, :csv

  helper_method :sort_column, :sort_direction

  has_scope :by_rack
  has_scope :by_mainteneur
  has_scope :by_system

  before_filter :select_view_mode

  def collection
    @machines ||= end_of_association_chain.search(params[:search]).order(sort_option)
    @racks = PhysicalRack.all.inject({}){|memo,elem| memo[elem.id] = elem; memo }
    @operating_systems = OperatingSystem.all.inject({}){|memo,elem| memo[elem.id] = elem; memo }
    @maintainers = Mainteneur.all.inject({}){|memo,elem| memo[elem.id] = elem; memo }
    if maintenance_mode?
      @machines = @machines.where(:virtual => false)
      if params[:sort] == "maintained_until"
        @machines = @machines.select{|m| m.maintained_until.present? } + @machines.select{|m| m.maintained_until.blank? }
      end
    end
  end

  private

  def select_view_mode
    session[:machines_view_mode] = params[:view_mode] if params[:view_mode]
  end

  def maintenance_mode?
    session[:machines_view_mode] == "maintenance"
  end
  helper_method :maintenance_mode?

  def view_mode
    maintenance_mode? ? "maintenance" : "normal"
  end
  helper_method :view_mode
end
