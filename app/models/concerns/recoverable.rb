# frozen_string_literal: true

module Recoverable
  extend ActiveSupport::Concern

  included do
    # вызывается перед обновлением записи, но после того, как валидации прошли
    # password_digest_changed? - был ли изменен password_digest в рамках текущей операции?
    # "password_digest_changed?" - автоматич. м-д RoR, потому что в БД есть колонка "password_digest"
    before_update :clear_reset_password_token, if: :password_digest_changed?

    def set_password_reset_token
      update_column :password_reset_token, digest(SecureRandom.urlsafe_base64)

      update_column :password_reset_token_sent_at, Time.current
    end

    # токены для сброса пароля становятся не валидными, как только пароль меняется
    def clear_reset_password_token
      self.password_reset_token = nil
      self.password_reset_token_sent_at = nil
    end

    # Прошло не более часа с момента того, как инструкции были отправлены (срок действия токена 1 ч)
    def password_reset_period_valid?
      password_reset_token_sent_at.present? && Time.current - password_reset_token_sent_at <= 60.minutes
    end
  end
end

# Мы юзера обновляем, потому что этот модуль будет к юзеру подключен
# config/application.rb - здесь настраивается временная зона (для Time.current)
