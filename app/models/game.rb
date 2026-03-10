class Game < ApplicationRecord
  has_many :collection_games
  has_many :collections, through: :collection_games

  validates :video_url, :release_date, presence: false
end
