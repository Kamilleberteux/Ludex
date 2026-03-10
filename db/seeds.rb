# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



Game.destroy_all
puts "Starting the creation of games"


# Add data seeding below

#=> Creer un ou deux users de test en DB

# default_collections


Game.create(name: "Cup The Crab",
description: "Dans Cup the Crab, les bernard-l'ermite parcourent la plage pour construire leur maison à partir de gobelets abandonnés. Ce jeu de cartes mélange gestion de main, timing et coups tactiques pour récupérer les meilleures piles de gobelets. Les joueurs collaborent pour créer des piles communes… mais la compétition reste intense lorsqu'il faut les récupérer au bon moment. Rapide, malin et plein de rebondissements, Cup the Crab propose des parties dynamiques où bluff et opportunisme font toute la différence.",
image_url_1: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/cup-the-crab_07e9211b-f0bc-43fa-9a2e-11b8e6bf1772.webp?v=1772880203",
image_url_2: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/cup-the-crab_07e9211b-f0bc-43fa-9a2e-11b8e6bf1772.webp?v=1772880203",
image_url_3: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/cup-the-crab_07e9211b-f0bc-43fa-9a2e-11b8e6bf1772.webp?v=1772880203",
is_cooperative: false,
level: "Familial",
nb_players: "3 à 5 joueurs",
play_time_minutes: "15 min",
price: 11.9,
)

Game.create(name: "Eternal Decks",
description: "Plongez dans Eternal Decks, un jeu de deck building coopératif où les joueurs unissent leurs forces pour résoudre des défis toujours plus complexes. Dans cet univers fantastique, l'humanité sombre dans un sommeil mystérieux et seule une expédition dans le monde des Éternels peut apporter une solution. Votre mission : construire votre deck, coopérer intelligemment et atteindre les objectifs de chaque niveau avant que l'équipe ne soit bloquée. Accessible mais stratégique, ce jeu propose une expérience coopérative intense et hautement rejouable.",
image_url_1: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/eternal-decks.jpg?v=1772879095",
image_url_2: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/eternal-decks.jpg?v=1772879095",
image_url_3: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/eternal-decks.jpg?v=1772879095",
is_cooperative: true,
level: "Initié",
nb_players: "1 à 4 joueurs",
play_time_minutes: "30 min",
price: 26.9,
video_url: "https://www.youtube.com/embed/_Q4YFCgS8kI?si=HUdDZ_i-GepHyb1R"
)

Game.create(name: "Apex Legends : Le Jeu de Plateau - Extension Kings Canyon",
description: "Cette extension ajoute de nouvelles tuiles de carte pour Apex Legends : Le Jeu de Plateau, inspirées du paysage industriel de Kings Canyon. Elle introduit de nouveaux bâtiments et éléments de terrain, notamment des clôtures servant d'obstacles infranchissables. Ce nouveau plateau peut être connecté au plateau de base grâce à des tuiles de jonction, élargissant ainsi la zone de combat potentielle. L'extension apporte également un nouveau mode de jeu, Point de Contrôle, ainsi que de nouvelles cartes prédéfinies.",
image_url_1: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/apex-legends-le-jeu-de-plateau-extension-plateau_1_dcace55f-caa2-4f21-bd68-b6bc4fcdea1b.webp?v=1772818209",
image_url_2: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/apex-legends-le-jeu-de-plateau-extension-plateau_1_dcace55f-caa2-4f21-bd68-b6bc4fcdea1b.webp?v=1772818209",
image_url_3: "https://cdn.shopify.com/s/files/1/0869/5998/0869/files/apex-legends-le-jeu-de-plateau-extension-plateau_1_dcace55f-caa2-4f21-bd68-b6bc4fcdea1b.webp?v=1772818209",
is_cooperative: false,
level: "Initié",
nb_players: "1 à 6 joueurs",
play_time_minutes: "60 à 90 min",
price: 26.9,
)

puts "Creation of games completed"
