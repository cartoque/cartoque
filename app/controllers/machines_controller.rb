class MachinesController < InheritedResources::Base
  respond_to :html, :js, :xml

  helper_method :sort_column, :sort_direction

  has_scope :by_rack
  has_scope :by_mainteneur

  before_filter :select_view_mode

  def collection
    @machines ||= end_of_association_chain.search(params[:search]).order(sort_column + " " + sort_direction)
    if maintenance_mode?
      @machines = @machines.where(:virtuelle => false)
      if params[:sort] == "maintained_until"
        @machines = @machines.select{|m| m.maintained_until.present? } + @machines.select{|m| m.maintained_until.blank? }
      end
    end
  end

  private
  def sort_column
    Machine.column_names.include?(params[:sort]) ? params[:sort] : "nom"
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end

  def select_view_mode
    session[:machines_view_mode] = params[:view_mode] if params[:view_mode]
  end

  def maintenance_mode?
    session[:machines_view_mode] == "maintenance"
  end
  helper_method :maintenance_mode?
end
