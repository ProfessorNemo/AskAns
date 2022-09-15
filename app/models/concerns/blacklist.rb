# frozen_string_literal: true

module Blacklist
  extend ActiveSupport::Concern

  included do
    validate :necessary_email
    validate :necessary_name
    validate :necessary_username

    private

    def blacklist
      @blacklist ||= Rails.root.join('db/blacklist.txt').readlines
      @blacklist.map(&:strip)
    end

    # проверка подходящего email для регистрации
    def necessary_email
      blacklist
      errors.add(:email, :registration_error) if blacklist.any?(email.split('@')[0])
    end

    # проверка подходящего имени для регистрации
    def necessary_name
      blacklist
      errors.add(:name, :registration_error) if blacklist.any?(name&.downcase)
    end

    # проверка подходящего имени для регистрации
    def necessary_username
      blacklist
      errors.add(:username, :registration_error) if blacklist.any?(username&.downcase)
    end
  end
end
