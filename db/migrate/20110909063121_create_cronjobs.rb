class CreateCronjobs < ActiveRecord::Migration
  def change
    create_table :cronjobs do |t|
      t.integer :server_id
      t.string :definition_location
      t.string :name
      t.string :frequency
      t.string :user
      t.text :command
      t.timestamps
    end
  end
end
