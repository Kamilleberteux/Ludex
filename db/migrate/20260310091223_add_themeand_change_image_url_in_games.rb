class AddThemeandChangeImageUrlInGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :theme, :string
    rename_column :games, :image_url, :image_url_1
    add_column :games, :image_url_2, :string
    add_column :games, :image_url_3, :string
  end
end
