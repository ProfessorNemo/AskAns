# frozen_string_literal: true

module API
  module V1
    class HashtagsController < RootController
      def index
        hashtags = Hashtag.arel_table
        # запрос - я хочу найти все хэштеги, заголовки которых
        # содержат слово "%#{params[:term]}%"
        @hashtags = Hashtag.where(hashtags[:text].matches("%#{params[:term]}%"))

        # Оставшиеся после удаления вопросов хэштеги
        @hashtags = helper_hashtag(1)
        # render(@hashtags) выполнит сериализацию и превратит коллекцию хэштегов в json
        success!(HashtagBlueprint.render_as_hash(@hashtags))
      end
    end
  end
end
