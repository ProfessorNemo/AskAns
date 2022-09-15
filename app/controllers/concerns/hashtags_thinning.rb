# frozen_string_literal: true

module HashtagsThinning
  extend ActiveSupport::Concern

  included do
    private

    # do_id либо 0 - хэштег, либо 1 - id
    # Извлечение массива отсортированных в алфавитном порядке хэштегов
    # class: array и actriverecird relations
    def helper_hashtag(do_id)
      hashtags = Hashtag.alphabetical_sorting

      return if hashtags.blank?

      Hashtag.with_questions.find choose(hashtags, do_id)
    end

    def choose(hashtags, do_id)
      hashtags['#']
        .filter_map { |x| x[do_id].respond_to?(:to_str) ? x[do_id] : x[1].to_i }
    end

    helper_method :helper_hashtag, :choose
  end
end
