# frozen_string_literal: true

require 'openssl'

class User < ApplicationRecord
  include Username

  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest.new('SHA256')

  # виртуальный аттрибут, не будет сохраняться в базу данных
  attr_accessor :password

  has_many :questions, dependent: :destroy

  #  без обращения к DNS-почтовым серверам для проверки существования доменного
  # проверяем корректность вводимых емэйлов
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true

  # валидация будет проходить только при создании нового юзера
  validates :password, presence: true, on: :create

  # и поле подтверждения пароля
  validates :password, confirmation: true

  # Перед сохранением пароля в базу его надо зашифровать. Для этого используем коллбэк:
  before_save :encrypt_password

  def encrypt_password
    return if password.blank?

    # Создаем т.н. «соль» — случайная строка, усложняющая задачу хакерам по
    # взлому пароля, даже если у них окажется наша БД.
    # У каждого юзера своя «соль», это значит, что если подобрать перебором пароль
    # одного юзера, нельзя разгадать, по какому принципу
    # зашифрованы пароли остальных пользователей
    self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

    # Создаем хэш пароля — длинная уникальная строка, из которой невозможно
    # восстановить исходный пароль. Однако, если правильный пароль у нас есть,
    # мы легко можем получить такую же строку и сравнить её с той, что в базе.
    self.password_hash = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    # Оба поля попадут в базу при сохранении (save).
  end

  # Служебный метод, преобразующий бинарную строку в шестнадцатиричный формат,
  # для удобства хранения.
  def self.hash_to_string(password_hash)
    password_hash.unpack1('H*')
  end

  # Основной метод для аутентификации юзера (логина). Проверяет email и пароль,
  # если пользователь с такой комбинацией есть в базе возвращает этого
  # пользователя. Если нету — возвращает nil.
  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    user = find_by(email: email)

    # Если пользователь не найден, возвращаем nil
    return nil if user.blank?

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password

    # Иначе, возвращаем nil
    nil
  end
end
