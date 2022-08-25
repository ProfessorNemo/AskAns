# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  # пристыковали для юзера новый метод и теперь можем свободно использовать его в меню
  def name_or_email
    return name if name.present?

    # отображать первую часть email
    email.split('@')[0].capitalize
  end

  def gravatar(size: 100, css_class: '')
    # Генерируем адрес изображения с размером по умолчанию "30 piks." + классы bootstrap
    # префикс "h" означает использования хэлпера RoR
    h.image_tag "https://www.gravatar.com/avatar/#{gravatar_hash}.jpg?s=#{size}",
                class: "rounded #{css_class}", alt: name_or_email
  end
end
