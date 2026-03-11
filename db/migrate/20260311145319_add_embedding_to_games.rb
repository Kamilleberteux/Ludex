class AddEmbeddingToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :embedding, :vector, limit: 768
  end
end
