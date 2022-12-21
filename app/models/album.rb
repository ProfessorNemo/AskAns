# frozen_string_literal: true

class Album < ApplicationRecord
  has_many_attached :album_photos
  belongs_to :user
end
