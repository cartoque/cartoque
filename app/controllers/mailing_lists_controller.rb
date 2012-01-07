class MailingListsController < InheritedResources::Base
  respond_to :html, :js

  def create
    create! { mailing_lists_url }
  end

  def update
    update! { mailing_lists_url }
  end

protected
  def collection
    @mailing_lists ||= end_of_association_chain.order("updated_at desc")
  end
end
