# frozen_string_literal: true

class User < ApplicationRecord
  include Username
  include Recoverable
  include Rememberable
  include Blacklist

  HEX_BACKGROUND_COLOR_REGEX = /\A#([\da-f]{3}){1,2}\z/
  DEFAULT_BACKGROUND_COLOR = '#005a55'

  # ролей может быть сколько угодно, наприер 3 - superadmin....
  # Например: "u.admin_role?" - здесь role - suffix
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role

  # Например: "u.activated_status?" - здесь role - suffix
  enum status: { activated: 0, blocked: 1 }, _suffix: :status

  # роль должна быть
  validates :role, presence: true

  # статус должен быть
  validates :status, presence: true

  # виртуальный аттрибут в БД попадать не будет, чтоб существовал
  # на объекте user метод old_password
  attr_accessor :old_password, :skip_old_password

  has_many :questions, dependent: :destroy

  has_many :albums, dependent: :destroy

  has_many :asked_questions,
           class_name: 'Question',
           foreign_key: :author_id,
           dependent: :nullify,
           inverse_of: :user

  has_secure_password validations: false

  # Эту валидацию нужно запускать только при обновлении записи и только  в том случае,
  # если новый пароль был указан. Если нет - значит юзер пароль менять не хочет, - игнорируем.
  # Если !skip_old_password - то юзеру старый пароль, который он не помнит, указывать не нужно
  validate :correct_old_password, on: :update, if: -> { password.present? && !skip_old_password }
  validates :password, confirmation: true, allow_blank: true,
                       length: { minimum: 8, maximum: 70 }

  # без обращения к DNS-почтовым серверам для проверки существования доменного
  # проверяем корректность вводимых емэйлов
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true

  validates :background_color, format: { with: HEX_BACKGROUND_COLOR_REGEX }, on: :update

  # before_save - функция обратного вызова, которая выполняется каждый раз перед тем,
  # как запись сохраняется в БД, когда email изменился с прошлого сохранения
  before_save :set_gravatar_hash, if: :email_changed?

  # сортировка юзеров по дате создания
  scope :sorted, -> { order(id: :desc) }
  # найти юзеров, у которых нет ни одного вопроса на странице
  scope :without_questions, -> { where.missing(:questions) }
  # (передаем в лямбду параметр "name") и получим массив юзеров с данным параметром
  scope :by_name, ->(name) { where(name: name) }

  validate :password_presence
  validate :password_complexity

  def bg_color
    background_color || DEFAULT_BACKGROUND_COLOR
  end

  # Юзер м.б. автором вопроса, ответа и т.д., поэтому "obj".
  # И скажем obj.author  == self (т.е.  obj.author  - это сам юзер).
  # У вопросов, или у любых других ресурсов есть метод "user"
  def author?(obj)
    obj.author == self
  end

  # не гость
  def guest?
    false
  end

  # сгенерировать api_token
  def generate_token
    transaction do
      if has_attribute?('api_token')
        update api_token: SecureRandom.alphanumeric(32)
        reload
      end
    end
  end

  private

  # функция обратного вызова
  def set_gravatar_hash
    return if email.blank?

    # Генерируем хэш на основе email-юзера, удаляем пробелы сначала и конца и преобразуем
    # его к нижнему регистру - это требования граватара. Потом на основе этого делаем хэш.
    hash = Digest::MD5.hexdigest email.strip.downcase

    # присвоить сохраняемой в данный момент записи (для которой выполнен callback) gravatar_hash
    # и установить его в значение hash. Перед тем, как юзера сохранить (user.save), к нему
    # пристыкуется еще значение "self.gravatar_hash = hash"
    self.gravatar_hash = hash
  end

  # сгенерировать хэш на основе строки
  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def correct_old_password
    # Если дайджесты совпали
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add(:old_password, :correct_error)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add(:password, :common_error)
  end

  def password_presence
    # Добавить для пароля сообщение, что он пустой
    errors.add(:password, :blank) if password_digest.blank?
  end
end
