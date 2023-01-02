# frozen_string_literal: true

class AlertUserPhotoAlbumJob < ApplicationJob
  discard_on ActiveJob::DeserializationError

  PATH = 'config/sidekiq.yml'
  queue_as :upload_photo
  sidekiq_options queue: YAML.load(ERB.new(Rails.root.join(PATH).read).result)[:queues][1]
  sidekiq_options retry: YAML.load(ERB.new(Rails.root.join(PATH).read).result)[:max_retries]

  rescue_from(StandardError) do
    retry_job wait: 10.minutes, queue: :upload_photo
  end

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
