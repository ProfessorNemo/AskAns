# frozen_string_literal: true

class AddEmailPasswordToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email, :string, null: false, default: 'usersmail@yandex.ru'
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
    add_column :users, :avatar_url, :string
  end
end
