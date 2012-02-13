class CreateMailingLists < ActiveRecord::Migration
  def change
    create_table :mailing_lists do |t|
      t.string :name
      t.text :comment
      t.timestamps
    end

    create_table :contacts_mailing_lists, id: false do |t|
      t.integer :contact_id
      t.integer :mailing_list_id
    end
  end
end
