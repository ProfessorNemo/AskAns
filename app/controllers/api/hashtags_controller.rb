# frozen_string_literal: true

module Api
  class HashtagsController < BaseController
    before_action :authorize_hashtag!
    after_action :verify_authorized

    def index
      hashtags = Hashtag.arel_table
      # запрос - я хочу найти все хэштеги, заголовки которых
      # содержат слово "%#{params[:term]}%"
      @hashtags = Hashtag.where(hashtags[:text].matches("%#{params[:term]}%"))

      # Оставшиеся после удаления вопросов хэштеги
      @hashtags = helper_hashtag(1)
      # render(@hashtags) выполнит сериализацию и превратит коллекцию хэштегов в json
      render json: HashtagBlueprint.render(@hashtags)
    end

    private

    # м-д "authorize" возьмется из базового контроллера "BaseController"
    def authorize_hashtag!
      authorize(@hashtag || Hashtag)
    end
  end
end
