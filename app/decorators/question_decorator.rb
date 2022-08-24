# frozen_string_literal: true

class QuestionDecorator < ApplicationDecorator
  delegate_all

  # Чтобы автоматически декорировать ту ассоциацию, которую мы вытаскиваем для вопроса
  decorates_association :user

  # "self" перед created_at не говорим, потому что метод вызывается
  # относительно конкретного образца класса
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
