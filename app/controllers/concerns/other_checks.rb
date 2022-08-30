# frozen_string_literal: true

module OtherChecks
  extend ActiveSupport::Concern

  included do
    private

    # Метод, который редиректит посетителя на главную с предупреждением о
    # нарушении доступа. Мы будем использовать этот метод, когда надо запретить
    # пользователю что-то.
    def reject_user
      flash[:danger] = t('.danger')
      redirect_back(fallback_location: root_path)
    end
  end
end
