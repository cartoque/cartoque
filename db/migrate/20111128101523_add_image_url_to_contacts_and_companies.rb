class AddImageUrlToContactsAndCompanies < ActiveRecord::Migration
  def change
    add_column :contacts, :image_url, :string, default: "ceo.png"
    add_column :companies, :image_url, :string, default: "building.png"
  end
end
