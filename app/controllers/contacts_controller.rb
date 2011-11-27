class ContactsController < InheritedResources::Base
  def index
    @companies = Company.all
    index!
  end
end
