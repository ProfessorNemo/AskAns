# frozen_string_literal: true

class QuestionDecorator < ApplicationDecorator
  delegate_all

  # Чтобы автоматически декорировать ту ассоциацию, которую мы вытаскиваем для вопроса
  decorates_association :user

  decorates_association :hashtag

  # "self" перед created_at не говорим, потому что метод вызывается
  # относительно конкретного образца класса
  def formatted_created_at
    l created_at, format: :long
  end
end
