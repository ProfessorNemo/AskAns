class ChangeOldColumnToNewColumn < ActiveRecord::Migration[6.1]
  def up
    rename_column :users, :password_salt, :password_digest
    rename_column :users, :password_hash, :remember_token_digest
  end

  def down
    rename_column :users, :password_digest, :password_salt
    rename_column :users, :remember_token_digest, :password_hash
  end
end
