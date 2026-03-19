class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :collections
  has_many :friendships
  has_many :friends, through: :friendships
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_default_collections # pour créer les collections par défaut à la création de l'utilisateur

  def has_game?(game)
    @games = collections.find_by(name: "Mes jeux").games
    @games.include?(game)
  end

  private

  def create_default_collections
    ["Déjà joué", "Mes jeux", "Wishlist"].each do |name|
      collections.create(name: name, is_default: true)
    end
  end
end
