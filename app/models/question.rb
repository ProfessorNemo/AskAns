# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  # рельсы добавят к нему `_id` и найдут нужное поле в таблице
  # валидация наличия объекта belongs_to происходит в случае,
  # если у этой связи не установлен ключ optional: true
  belongs_to :author,
             class_name: 'User',
             optional: true

  validates :text, presence: true, length: { minimum: 1, maximum: 255 }
end
