# frozen_string_literal: true

class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :archive
      t.timestamps
    end
  end
end
