# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  validates :text, presence: true, length: { minimum: 1, maximum: 255 }
end
