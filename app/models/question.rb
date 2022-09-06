# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  # рельсы добавят к нему `_id` и найдут нужное поле в таблице
  # валидация наличия объекта belongs_to происходит в случае,
  # если у этой связи не установлен ключ optional: true
  belongs_to :author,
             class_name: 'User',
             optional: true

  has_many :question_hashtags, dependent: :destroy
  has_many :hashtags, through: :question_hashtags

  validates :text, presence: true, length: { minimum: 1, maximum: 255 }

  after_save_commit :create_hashtags

  # те вопросы, у которых поле "answer" не содержит nil
  scope :answered, -> { where.not(answer: nil) }
  # те вопросы, у которых поле "answer" содержит nil (не отвеченные)
  scope :unanswered, -> { where(answer: nil) }

  scope :sorted, -> { order(created_at: :desc) }

  private

  def parse_hashtags(string)
    string.to_s.split.map(&:downcase)
          .map { |str| "##{str}" }.sample(3)
          .map { |i| i.scan(Hashtag::REGEX) }
          .flatten
  end

  def create_hashtags
    self.hashtags =
      parse_hashtags(text.to_s).uniq.map do |hashtag|
        Hashtag.create_or_find_by(text: hashtag)
      end
  end
end
