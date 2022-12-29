# frozen_string_literal: true

class AlbumMailer < ApplicationMailer
  def photo(album, email, photos)
    @album = album
    @photos = photos

    mail(to: email,
         subject: default_i18n_subject(user: album.user.name, album: album.title))
  end
end
