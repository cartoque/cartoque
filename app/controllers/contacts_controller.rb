class ContactsController < InheritedResources::Base
  before_filter :find_companies_and_contacts_count, :only => :index

  def index
    @companies = Company.all
    index!
  end

  private
  def collection
    @contacts ||= end_of_association_chain.limit(10).order("updated_at desc")
  end

  def find_companies_and_contacts_count
    @companies_count = Company.count
    @contacts_count  = Contact.count
  end
end
