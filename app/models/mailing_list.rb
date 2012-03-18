class MailingList < ActiveRecord::Base
  validates_presence_of :name

  #TEMPORARY
  def contact_ids
    if new_record?
      []
    else
      ActiveRecord::Base.connection.execute("SELECT contact_mongo_id FROM contacts_mailing_lists WHERE mailing_list_id=#{self.id};").to_a.flatten
    end
  end

  #TEMPORARY
  def contacts
    Contact.where(:_id.in => contact_ids)
  end

  #TEMPORARY
  def contact_ids=(ids)
    #Nothing for now, will soon be replaced by a mongoid version
    []
  end
end
