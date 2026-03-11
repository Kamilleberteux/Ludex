class Game < ApplicationRecord
  has_many :collection_games, dependent: :destroy
  has_many :collections, through: :collection_games
  validates :video_url, :release_date, presence: false


  def photo_urls
    [image_url_1, image_url_2, image_url_3].compact
  end
end
