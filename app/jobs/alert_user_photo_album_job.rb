# frozen_string_literal: true

class AlertUserPhotoAlbumJob < ApplicationJob
  queue_as :upload_photo

  def perform(initiator, album, n_add)
    photos = album.album_photos.order(created_at: :desc).limit(n_add)

    all_emails = (User.pluck(:email) - [initiator.email])

    departure(album, all_emails, photos) { |mail| message(album, mail, photos) }
  end

  private

  def message(*args)
    AlbumMailer.photo(*args).deliver_now
  end

  def departure(*args, &block)
    return unless block

    args[1].each(&block)
  end
end
