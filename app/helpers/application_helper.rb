# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'AskMe'
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
end
