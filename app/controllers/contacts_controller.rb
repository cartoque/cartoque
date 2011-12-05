class ContactsController < InheritedResources::Base
  before_filter :find_companies_and_contacts_count, :only => :index

  respond_to :html, :js

  def index
    params[:sort] ||= "updated_at"
    params[:direction] ||= "desc"
    @companies = Company.search(params[:search]).limit(params[:all_companies].blank? ? 25 : nil).order(sort_option.gsub(/(last|first)_name/, "name"))
    index!
  end

  private
  def collection
    @contacts ||= end_of_association_chain.search(params[:search]).limit(params[:all_contacts].blank? ? 25 : nil).order(sort_option)
  end

  def find_companies_and_contacts_count
    @companies_count = Company.search(params[:search]).count
    @contacts_count  = Contact.search(params[:search]).count
  end

  def full_display?(contact)
    contact == @contact
  end
  helper_method :full_display?
  
  include SortHelpers
  helper_method :sort_column, :sort_direction, :sort_column_prefix
end
