class ChangeTypesInGames < ActiveRecord::Migration[8.1]
  def change
    change_column :games, :play_time_minutes, :string
    change_column :games, :price, :float
  end
end
