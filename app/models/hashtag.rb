# frozen_string_literal: true

class Hashtag < ApplicationRecord
  REGEX = /#[[:word:]-]+/

  has_many :question_hashtags, dependent: :destroy
  has_many :questions, through: :question_hashtags

  validates :text, presence: true, format: { with: REGEX }

  scope :with_questions, -> { joins(:questions).distinct }

  before_validation :convert_downcase

  private

  def convert_downcase
    text&.downcase!
  end
end
