class ContactsController < InheritedResources::Base
  before_filter :find_companies_and_contacts_count, only: :index

  respond_to :html, :js

  def index
    params[:sort] ||= "updated_at"
    params[:direction] ||= "desc"
    companies_sort_option = sort_option.gsub(/(last|first)_name/, "name").gsub("contacts.", "companies.")
    @companies = Company.with_internals(view_internals)
                        .search(params[:search])
                        .limit(params[:all_companies].blank? ? 25 : nil)
                        .includes(:email_infos, :phone_infos, :contacts)
                        .order(companies_sort_option)
    index!
  end

  def autocomplete
    render js: Contact.search(params[:q]).limit(25).map{|contact| { id: contact.id, name: contact.full_name } }.to_json
  end

  private
  def collection
    @contacts ||= end_of_association_chain.with_internals(view_internals)
                                          .search(params[:search])
                                          .limit(params[:all_contacts].blank? ? 25 : nil)
                                          .includes(:email_infos, :phone_infos, :company)
                                          .order(sort_option)
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

  def sort_column_prefix
    "contacts."
  end
  helper_method :sort_column, :sort_direction, :sort_column_prefix

  before_filter :select_view_mode
  def select_view_mode
    current_user.update_setting(:contacts_view_internals, params[:with_internals]) if params[:with_internals] && current_user
  end

  def view_internals
    current_user && current_user.settings["contacts_view_internals"].to_i == 1
  end
  helper_method :view_internals
end
