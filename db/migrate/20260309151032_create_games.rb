class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :name
      t.string :description
      t.string :image_url
      t.string :video_url
      t.integer :nb_players
      t.integer :play_time_minutes
      t.string :level
      t.boolean :is_cooperative
      t.integer :price
      t.integer :release_date

      t.timestamps
    end
  end
end
