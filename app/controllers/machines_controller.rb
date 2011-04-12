class MachinesController < InheritedResources::Base
  respond_to :html, :js, :xml

  helper_method :sort_column, :sort_direction

  alias :maintenance :index

  def collection
    @machines ||= end_of_association_chain.search(params[:search]).order(sort_column + " " + sort_direction)
    if self.action_name == "maintenance"
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
end
