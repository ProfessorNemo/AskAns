# frozen_string_literal: true

module API
  module V1
    class QuestionsController < RootController
      def index
        @user = User.where(username: params[:user_username]).take
        @questions = @user.questions
        success!(QuestionBlueprint.render_as_hash(@questions, view: :normal))
      end
    end
  end
end
