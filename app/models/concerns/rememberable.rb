# frozen_string_literal: true

# Функционал, связанный с запоминанием юзера
module Rememberable
  extend ActiveSupport::Concern

  included do
    attr_accessor :remember_token

    # rubocop:disable Rails/SkipsModelValidations
    # сгенерировать token (абракадабра), на основе которого будем делать хэш
    def remember_me
      # self - чтобы пристыковать виртуальный аттрибут "remember_token" к текущему юзеру
      self.remember_token = SecureRandom.urlsafe_base64
      # поместить token в табличку c помощью update_column
      update_column :remember_token_digest, digest(remember_token)
    end

    # Когда юзер выходит из системы, нам нужно всю информацию о нем очистить
    def forget_me
      update_column :remember_token_digest, nil

      # не обязательно, в целях полноты
      self.remember_token = nil
    end
    # rubocop:enable Rails/SkipsModelValidations

    # Проверить, что тот token, который нам передается и тот, которы в БД - одно и то же
    def remember_token_authenticated?(remember_token)
      return false if remember_token_digest.blank?

      # Хэш "remember_token_digest" такой же, который получается из строки "remember_token"
      BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
    end
  end
end