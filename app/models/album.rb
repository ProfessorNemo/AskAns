# frozen_string_literal: true

class Album < ApplicationRecord
  include Authorship

  LEN = (3..30)
  has_many_attached :album_photos
  belongs_to :user
  belongs_to :author_album,
             class_name: 'User',
             foreign_key: :user_id,
             optional: true

  validates :title, presence: true, length: { in: LEN }
  validates :description, presence: true, length: { in: LEN }
  validates :album_photos, blob: { content_type: %w[image/png image/jpg image/jpeg], size_range: 0.1..(15.megabytes) }
  # в альбоме не больше 300 фотографий
  validates :album_photos, limit: { max: 300 }

  # validate :check_title
  # validate :check_description

  def attributes
    super.merge({
                  'image_urls' => image_urls,
                  'image_count' => image_count
                })
  end

  # массив ссылок на все фотографии в альбоме
  def image_urls
    return unless album_photos.attached?

    album_photos.map(&:service_url)
  end

  # количество фотографий в каждом альбоме
  def image_count
    return unless album_photos.attached?

    album_photos.count
  end

  private

  def check_title
    errors.add(:title, :title_error) if title.length > LEN.last
  end

  def check_description
    errors.add(:description, :description_error) if description.length > LEN.last
  end
end
