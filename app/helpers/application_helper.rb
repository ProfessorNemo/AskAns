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

  # do_id либо 0 - хэштег, либо 1 - id
  # Извлечение массива отсортированных в алфавитном порядке хэштегов
  # class: array и actriverecird relations
  def helper_hashtag(do_id)
    hashtags = Hashtag.alphabetical_sorting

    hashtags.extend Hashie::Extensions::DeepFind

    Hashtag.with_questions.find choose(hashtags, do_id)
  end

  def choose(hashtags, do_id)
    hashtags.deep_find('#')
            .filter_map { |x| x[do_id].respond_to?(:to_str) ? x[do_id] : x[1].to_i }
  end
end
