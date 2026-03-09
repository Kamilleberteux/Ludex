class Game < ApplicationRecord
  has_many :collections, throught: :collection_games
end
