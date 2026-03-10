class AddAgePlayerToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :age_player, :string
  end
end
