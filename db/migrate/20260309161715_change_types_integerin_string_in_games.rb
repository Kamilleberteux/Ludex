class ChangeTypesIntegerinStringInGames < ActiveRecord::Migration[8.1]
  def change
    change_column :games, :play_time_minutes, :string
    change_column :games, :nb_players, :string
    change_column :games, :price, :float
    change_column :games, :release_date, :string
  end
end
