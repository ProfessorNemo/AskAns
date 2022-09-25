# frozen_string_literal: true

module Api
  class UsersController < BaseController
    before_action :authorize_user!
    after_action :verify_authorized

    def index
      @users = User.all

      render json: UserBlueprint.render(@users)
    end

    private

    # м-д "authorize" возьмется из базового контроллера "BaseController"
    def authorize_user!
      authorize(@user || User)
    end
  end
end
