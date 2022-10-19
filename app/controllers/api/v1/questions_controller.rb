# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < RootController
      def index
        # @user = User.where(role: 'admin').take
        @user = User.find(params[:user_id])
        @questions = @user.questions
        render json: QuestionBlueprint.render(@questions, view: :normal)
      end
    end
  end
end
