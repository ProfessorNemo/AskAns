# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    # по умолчанию все с правами доступа юзера ("default: 0, null: false")
    add_column :users, :role, :integer, default: 0, null: false
    # индекс добавить на роль
    add_index :users, :role
  end
end