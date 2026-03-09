# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def self.up
    change_table :users do |t|
      t.string :username
      t.string :city
      t.string :profile_photo_url
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
