class CompaniesController < InheritedResources::Base
  respond_to :html, :json

  def destroy
    destroy! { contacts_path }
  end

  def autocomplete
    @companies = Company.order_by([:name, :asc]).where(name: Regexp.new(params[:term], Regexp::IGNORECASE))
    render json: @companies.map(&:name)
  end

  def full_display?(company)
    company == @company
  end
  helper_method :full_display?
end
