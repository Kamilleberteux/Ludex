class Game < ApplicationRecord
  include Neighbor::Model

  has_many :collection_games, dependent: :destroy
  has_many :collections, through: :collection_games
  validates :video_url, :release_date, presence: false
  after_create :generate_embedding!

  has_neighbors :embedding

  def photo_urls
    [image_url_1, image_url_2, image_url_3].compact
  end

  def self.embedding_model
    @embedding_model ||= Informers.pipeline(
      "embedding",
      "sentence-transformers/all-mpnet-base-v2"
    )
  end

  def self.embed(text)
    embedding_model.call(text)
  end

  def generate_embedding!
    update!(embedding: self.class.embed("#{name} - #{description} - #{nb_players} - #{play_time_minutes}"))
  end


end
