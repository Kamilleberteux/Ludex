class Collection < ApplicationRecord
  belongs_to :user
  has_many :games, throught: :collection_games
end
