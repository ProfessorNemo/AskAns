# frozen_string_literal: true

class RemoveDefaultEmailNullFromQuestionsAnswers < ActiveRecord::Migration[6.1]
  # up и down - методы, которые вызываются при применении миграции и при откате

  # def up
  #   change_column_default :users, :email, from: 'usersmail@yandex.ru', to: nil
  # end

  # # Возврат на шаг назад, т.е. наоборот
  # def down
  #   change_column_default :users, :email, from: nil, to: 'usersmail@yandex.ru'
  # end

  # Если напрямую клонировать код и применять все миграции подряд
  def change
    return unless User.all.any?

    change_column_default :users, :email, from: 'usersmail@yandex.ru', to: nil
  end
end
