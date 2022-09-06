# frozen_string_literal: true

class HashtagsController < ApplicationController
  def show
    @hashtag = Hashtag.with_questions.find_by!(text: params[:text])
    @questions = @hashtag.questions.includes(:author, :user, :question_hashtags).sorted
  end
end
