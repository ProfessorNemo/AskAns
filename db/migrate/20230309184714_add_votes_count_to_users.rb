# frozen_string_literal: true

class AddVotesCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :votes_count, :integer, default: 0
  end
end
