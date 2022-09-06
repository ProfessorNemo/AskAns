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

  scope :all_by_hashtags, lambda { |hashtags|
    questions = includes(:user)
    questions = if hashtags
                  # связка в SQL с таблице хэштегов, только если они существуют
                  questions.joins(:hashtags).where(hashtags: hashtags).preload(:hashtags)
                else
                  questions.includes(:question_hashtags, :hashtags)
                end
    # либо выбираем все вопросы
    questions.order(created_at: :desc)
  }

  private

  # выбираем любые 2 слова из вопроса в качестве хэштега,
  # содержащие от 2 до 10 букв
  def parse_hashtags(string)
    string.downcase.split
          .select { |i| i.chars.count.between?(2, 10) }
          .map { |i| i.delete('^a-zA-Zа-яА-Я') }
          .uniq.sample(2)
  end

  # генератор хэштега
  def create_hashtags
    self.hashtags =
      parse_hashtags(text).map do |hashtag|
        Hashtag.create_or_find_by(text: "##{hashtag}")
      end
  end
end
