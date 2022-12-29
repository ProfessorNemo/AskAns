# frozen_string_literal: true

class AddNotificationsToAlbums < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :notifications, :boolean, default: false
  end
end
