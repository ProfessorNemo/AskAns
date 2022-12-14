# frozen_string_literal: true

class Hashtag < ApplicationRecord
  has_many :question_hashtags, dependent: :destroy
  has_many :questions, through: :question_hashtags

  validates :text, presence: true

  # Все те хэштеги, у которых есть вопросы
  # scope :with_questions, -> { joins(:questions).distinct }
  #
  # или
  #
  # Все те хэштеги, у которых есть вопросы (экономия ресурсов ЦП, не используем join)
  scope :with_questions, -> { where_exists(:question_hashtags) }

  scope :alphabetical_sorting, lambda {
    joins(:questions).distinct
                     .order(:text).map { |tag| [tag.text, tag.id] }
                     .group_by { |tag| tag.first[0, 1].upcase }
  }
end
