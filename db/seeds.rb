# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'csv'
require 'nokogiri'

Game.destroy_all
puts "Starting the creation of games from CSV"

csv_path = Rails.root.join('public', 'products_export_1.csv')
rows = CSV.read(csv_path, headers: true, encoding: 'UTF-8')

# Group rows by Handle, preserving order
products = {}
rows.each do |row|
  handle = row['Handle']
  next if handle.nil? || handle.strip.empty?
  products[handle] ||= []
  products[handle] << row
end

def players_number(cell)
  if cell != nil
    if cell.include?("Difficulté")
      return nil
    else
      return cell
    end
  end
end

def play_time(cell)
    # Parse HTML body
  if cell == "quelques heures ..."
    return "180 min et +"
  else
    return cell
  end
end

def level_eval(age)
  if age == "5 ans et +"
    "Enfant"
  elsif age == "10 ans et +"
    "Familial"
  elsif age == "12 ans et +"
    "Initié"
  elsif age == "16 ans et +"
    "Expert"
  else
    return nil
  end
end

products.each do |handle, product_rows|
  # Main row = the one with a Title
  main_row = product_rows.find { |r| r['Title'].present? }
  next unless main_row

  # Only process actual games, not events or tournaments
  category = main_row['Product Category'].to_s
  next unless category.include?('Toys & Games > Games')

  name = main_row['Title']
  price = main_row['Variant Price'].to_f

  # Parse HTML body
  html_body = main_row['Body (HTML)'].to_s
  doc = Nokogiri::HTML(html_body)

  # Extract nb_players, play_time_minutes, age_player from the first table row
  table_cells = doc.css('table td').map { |td| td.text.strip }.reject(&:empty?)
  nb_players       = table_cells[0]

  # Parse min/max players from nb_players string (e.g. "2-4", "2 à 6", "4")
  nb_players_min, nb_players_max = if nb_players =~ /(\d+)\s*[-à]\s*(\d+)/
    [$1.to_i, $2.to_i]
  elsif nb_players =~ /(\d+)/
    [$1.to_i, $1.to_i]
  else
    [nil, nil]
  end
  play_time_minutes = table_cells[1]
  age_from_table   = table_cells[2]

  # Extract video URL from iframe
  video_url = doc.css('iframe').first&.attr('src')

  # Build plain-text description (remove table and iframes)
  doc.css('table, iframe').remove
  description = doc.css('body').text.gsub(/\s+/, ' ').strip.presence

  # is_cooperative: rely on the Tags field
  tags = main_row['Tags'].to_s.downcase
  is_cooperative = tags.include?('cooperative')

  # age_player: prefer from table, fallback to the recommended-age-group metafield
  age_player = age_from_table.presence ||
               main_row['Tranche d\'âge recommandée (product.metafields.shopify.recommended-age-group)']

  # theme
  theme = main_row['Thème (product.metafields.shopify.theme)'].presence

  # Collect image URLs indexed by position (1, 2, 3)
  images = {}
  product_rows.each do |row|
    position = row['Image Position'].to_i
    src = row['Image Src'].to_s.strip
    next if src.empty? || position.zero?
    images[position] ||= src
  end

  game = Game.new(
    name:              name,
    description:       description,
    nb_players:        nb_players,
    nb_players_min:    nb_players_min,
    nb_players_max:    nb_players_max,
    play_time_minutes: play_time_minutes,
    age_player:        age_player,
    price:             price,
    is_cooperative:    is_cooperative,
    theme:             theme,
    video_url:         video_url,
    image_url_1:       images[1],
    image_url_2:       images[2],
    image_url_3:       images[3],
    release_date:      rand(1999..2025),
    level:             level_eval(age_player)
    )

  game.theme = game.theme.split(";").first if theme != nil
  game.save!
  puts "Created: #{name}"

puts "Creation of games completed"
end
