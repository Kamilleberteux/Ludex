class AddCustomFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username, :string
    add_column :users, :city, :string
    add_column :users, :profile_photo_url, :string
  end
end
