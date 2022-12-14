# frozen_string_literal: true

class RemoveBadColumnNames < ActiveRecord::Migration[6.1]
  def up
    remove_column :users, :avatar_url
  end

  def down
    add_column :users, :avatar_url, :string
  end
end
