Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

migration

friendship : foreign_key:true { to_table user }

m F
belongs_to friend, class_name: "User"

U
has_m frships
has_m friends through fships

show game :
if jeux in a friend collection "Mes jeux" alors pastille des amis possèdes ce jeux (photos profil cote à cote) quand tu clique dropdown lien collection amis

friendship -> collections -> jeux

user.rb
has_game? (game)
collection(name:"Mes jeux").include?

game controller


scope dans model
scope:pending where status = pending -> retourne un array
pour chaque user scope dans la collection possèdé


Adrien
