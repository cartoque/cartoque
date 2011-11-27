class AddCommentToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :comment, :text
  end
end
