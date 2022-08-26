# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  # добавить в класс, где модуль ErrorHandling был подключен
  included do
    # Обрабатывать ошибку «ActiveRecord::RecordNotFound» в методе «notfound»
    rescue_from ActiveRecord::RecordNotFound, with: :notfound

    private

    def notfound(exception)
      # записать ошибку exception в журнал событий RoR
      logger.warn exception
      # код состояния 404 not_found
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end
end
