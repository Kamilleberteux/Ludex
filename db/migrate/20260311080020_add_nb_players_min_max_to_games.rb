class AddNbPlayersMinMaxToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :nb_players_min, :integer
    add_column :games, :nb_players_max, :integer
  end
end
