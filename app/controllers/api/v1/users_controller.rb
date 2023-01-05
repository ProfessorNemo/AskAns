# frozen_string_literal: true

module API
  module V1
    class UsersController < RootController
      def index
        @users = User.all

        success!(UserBlueprint.render_as_hash(@users))
      end
    end
  end
end
