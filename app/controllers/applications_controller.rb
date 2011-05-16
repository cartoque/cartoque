class ApplicationsController < InheritedResources::Base
  include SortHelpers

  respond_to :html, :js, :xml

  helper_method :sort_column, :sort_direction

  def show
    super do |format|
      format.xml { render :xml => @application.to_xml(:include => :machines) }
    end
  end

  def collection
    @applications ||= end_of_association_chain.search(params[:search]).order(sort_column + " " + sort_direction)
  end
end

#super dirty patch for rails ticket #4840
#TODO: remove it when Rails 3.0.5 is here...
class NilClass
  def type
    nil
  end
end
