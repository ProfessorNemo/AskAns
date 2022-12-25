# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  include UsersHelper

  # данная навигация показывается в том случае, если количество страниц больше 1
  def pagination(obj)
    # raw - для обработки разметки правильным образом
    # rubocop:disable Rails/OutputSafety
    raw(pagy_bootstrap_nav(obj)) if obj.pages > 1
    # rubocop:enable Rails/OutputSafety
  end

  def full_title(page_title = '')
    base_title = 'AskAns'
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  # Хелпер, рисующий span тэг с иконкой из font-awesome
  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  # для того, чтобыт при выборе локали не редиректило каждый раз на главную страницу
  def params_plus(additional_params)
    params.to_unsafe_h.merge(additional_params)
  end

  def language_bar
    I18n.locale.to_s == 'en' ? 'england' : 'ru'
  end

  # Возвращает адрес рандомной фотки, если есть хотя бы одна
  # Или ссылку на дефолтную картинку по умолчанию
  def album_photo(album)
    if album.album_photos.any?
      photo = album.album_photos.sample

      # url = ActiveStorage::Blob.service.path_for(photo.key)
      url = photo.url
    else
      url = asset_path('bg.png')
    end

    url
  end
end
