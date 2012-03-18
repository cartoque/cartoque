class ContactsController < InheritedResources::Base
  before_filter :find_companies_and_contacts_count, only: :index

  respond_to :html, :js

  def index
    params[:sort] ||= "updated_at"
    params[:direction] ||= "desc"
    companies_sort_option = mongo_sort_option.inject([]) { |memo, ary| memo = [ary[0].gsub(/(last|first)_name/, "name"), ary[1]]}
    @companies = Company.with_internals(view_internals)
                        .like(params[:search])
                        .limit(params[:all_companies].blank? ? 25 : nil)
                        .order_by(companies_sort_option)
    index!
  end

  def autocomplete
    render js: Contact.like(params[:q]).limit(25).map{|contact| { id: contact.id, name: contact.full_name } }.to_json
  end

  private
  def collection
    @contacts ||= end_of_association_chain.with_internals(view_internals)
                                          .like(params[:search])
                                          .limit(params[:all_contacts].blank? ? 25 : nil)
                                          .order_by(mongo_sort_option)
  end

  def find_companies_and_contacts_count
    @companies_count = Company.like(params[:search]).count
    @contacts_count  = Contact.like(params[:search]).count
  end

  def full_display?(contact)
    contact == @contact
  end
  helper_method :full_display?
  
  include SortHelpers
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
