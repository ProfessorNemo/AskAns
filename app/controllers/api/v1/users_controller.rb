# frozen_string_literal: true

module Api
  module V1
    class UsersController < RootController
      def index
        @users = User.all

        render json: UserBlueprint.render(@users)
      end
    end
  end
end