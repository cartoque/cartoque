class CreateBackupExceptions < ActiveRecord::Migration
  def change
    create_table :backup_exceptions do |t|
      t.string :user_id
      t.text   :reason
      t.timestamps
    end

    create_table :backup_exceptions_servers, id: false do |t|
      t.integer :backup_exception_id
      t.integer :server_id
    end
  end
end
