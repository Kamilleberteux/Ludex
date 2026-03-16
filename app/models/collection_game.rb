class CollectionGame < ApplicationRecord
  belongs_to :collection
  belongs_to :game

  validates :game_id, uniqueness: { scope: :collection_id, message: "Ce jeu est déjà dans cette collection" }
end
