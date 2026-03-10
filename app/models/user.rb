class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :collection
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_default_collections #pour créer les collections par défaut à la création de l'utilisateur


  private

  def create_default_collections
    ["Déjà joué", "Mes jeux", "Whislist"].each do |name|
      self.collections.create(name: name, is_default: true)
    end
  end
end
