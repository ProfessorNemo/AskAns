# frozen_string_literal: true

module Api
  class HashtagsController < ApplicationController
    def index
      hashtags = Hashtag.arel_table
      # запрос - я хочу найти все теги, заголовки которых
      # содержат слово "%#{params[:term]}%"
      @hashtags = Hashtag.where(hashtags[:text].matches("%#{params[:term]}%"))

      # render(@tags) выполнит сериализацию и превратит коллекцию тегов в json
      render json: HashtagBlueprint.render(@hashtags)
    end
  end
end
