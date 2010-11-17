class ApplicationsController < InheritedResources::Base
  helper_method :sort_column, :sort_direction

  def collection
    @applications ||= end_of_association_chain.search(params[:search]).order(sort_column + " " + sort_direction)
  end

  private
  def sort_column
    Application.column_names.include?(params[:sort]) ? params[:sort] : "nom"
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end
end
