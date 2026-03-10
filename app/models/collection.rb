class Collection < ApplicationRecord
  belongs_to :user
  has_many :games, through: :collection_games
end
