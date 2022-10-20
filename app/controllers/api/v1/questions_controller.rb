# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < RootController
      def index
        @user = User.where(username: params[:user_username]).take
        @questions = @user.questions
        render json: QuestionBlueprint.render(@questions, view: :normal)
      end
    end
  end
end
