# frozen_string_literal: true

class RemoveDefaultUserIdFromQuestions < ActiveRecord::Migration[6.1]
  # Если напрямую клонировать код и применять все миграции подряд
  def change
    return unless User.all.any?

    change_column_default :questions, :user_id, from: User.first.id, to: nil
  end
end
