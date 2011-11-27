class CompaniesController < InheritedResources::Base
  respond_to :html, :json

  def autocomplete
    @companies = Company.order(:name).where("name like ?", "%#{params[:term]}%")
    render :json => @companies.map(&:name)
  end
end
