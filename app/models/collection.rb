class Collection < ApplicationRecord
  belongs_to :user
  has_many :games, throught: :collection_games
end

# affiche un petit + a cote de la collection poour aller sur un seazrch et aller cherche le jeu
# si pas de jeu dans la collection, afficher un message "Votre collection est vide!
