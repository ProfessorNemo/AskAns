# frozen_string_literal: true

module API
  module V1
    class RootController < ApplicationController
      before_action :ensure_user_authorized

      private

      # авторизоваться через заголовок запроса
      def ensure_user_authorized
        token = request
                .headers.env.reject { |key| key.to_s.include?('.') }['QUERY_STRING']
                .delete_prefix('api_token=')

        @current_user = User.where.not(api_token: nil)
                            .find_by(api_token: token)

        return head(:forbidden) unless @current_user
      end
    end
  end
end
