# frozen_string_literal: true

module Api
  class HashtagsController < ApplicationController
    def index
      hashtags = Hashtag.arel_table
      # запрос - я хочу найти все хэштеги, заголовки которых
      # содержат слово "%#{params[:term]}%"
      @hashtags = Hashtag.where(hashtags[:text].matches("%#{params[:term]}%"))

      # Оставшиеся после удаления вопросв хэштеги
      @hashtags = helper_hashtag(1)
      # render(@tags) выполнит сериализацию и превратит коллекцию хэштегов в json
      render json: HashtagBlueprint.render(@hashtags)
    end
  end
end
