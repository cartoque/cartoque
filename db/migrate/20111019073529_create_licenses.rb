class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :editor
      t.string :key
      t.string :title
      t.string :quantity
      t.date :purshased_on
      t.date :renewal_on
      t.text :comment

      t.timestamps
    end
  end
end
