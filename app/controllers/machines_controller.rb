class MachinesController < InheritedResources::Base
  respond_to :html, :js, :xml

  helper_method :sort_column, :sort_direction

  def collection
    @machines ||= end_of_association_chain.search(params[:search]).order(sort_column + " " + sort_direction)
  end

  def maintenance
    @machines = Machine.where(:virtuelle => false).all(:order => "nom")
  end

  private
  def sort_column
    Machine.column_names.include?(params[:sort]) ? params[:sort] : "nom"
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end
end
