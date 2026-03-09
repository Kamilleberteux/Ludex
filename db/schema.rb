# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_09_151747) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "collection_games", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_games_on_collection_id"
    t.index ["game_id"], name: "index_collection_games_on_game_id"
  end

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_default"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "image_url"
    t.boolean "is_cooperative"
    t.string "level"
    t.string "name"
    t.integer "nb_players"
    t.integer "play_time_minutes"
    t.integer "price"
    t.integer "release_date"
    t.datetime "updated_at", null: false
    t.string "video_url"
  end

  create_table "users", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "profile_photo_url"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collection_games", "collections"
  add_foreign_key "collection_games", "games"
  add_foreign_key "collections", "users"
end
