class MailingListsController < InheritedResources::Base
  respond_to :html, :js

  def new
    if params[:search_contact]
      term = "%#{params[:search_contact]}%"
      @contacts = Contact.order(:last_name).includes(:company).joins(:email_infos) #.group("contacts.id")
                          .where("first_name like ? OR last_name like ? OR companies.name like ?", term, term, term)
    else
      @contacts = []
    end
    new!
  end
end
