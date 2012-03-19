# temp class for active_record versions of objects
class ARMailingList < ActiveRecord::Base
  self.table_name = "mailing_lists"

  def contact_ids
    ActiveRecord::Base.connection.execute("SELECT contact_mongo_id FROM contacts_mailing_lists WHERE mailing_list_id=#{self.id};").to_a.flatten
  end
end

# migration!
class MigrateMailingListsToMongoid < ActiveRecord::Migration
  def up
    MailingList.destroy_all
    cols = ARMailingList.column_names - %w(id )
    ARMailingList.all.each do |mailing_list|
      attrs = mailing_list.attributes.slice(*cols)
      attrs["contact_ids"] = mailing_list.contact_ids
      MailingList.create(attrs)
    end
  end

  def down
    #nothing for now! maybe a bit of cleanup later?
  end
end
