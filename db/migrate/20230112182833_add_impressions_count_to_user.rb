# frozen_string_literal: true

class AddImpressionsCountToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :impressions_count, :integer, default: 0
  end
end
