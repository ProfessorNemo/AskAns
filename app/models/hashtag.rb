# frozen_string_literal: true

class Hashtag < ApplicationRecord
  has_many :question_hashtags, dependent: :destroy
  has_many :questions, through: :question_hashtags

  validates :text, presence: true

  scope :with_questions, -> { joins(:questions).distinct }
end
