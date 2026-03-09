class Game < ApplicationRecord
  has_many :collections, throught: :collection_games

  validates :video_url, :release_date, presence: false
end
