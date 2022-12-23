# frozen_string_literal: true

class Album < ApplicationRecord
  include Authorship

  has_many_attached :album_photos
  belongs_to :user

  belongs_to :author_album,
             class_name: 'User',
             foreign_key: :user_id,
             optional: true
end
