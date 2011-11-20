class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :job_position
      t.string :company
      t.string :phone
      t.string :mobile
      t.string :email
      t.text :comment
      t.timestamps
    end
  end
end
