# frozen_string_literal: true

module API
  module V1
    class RootController < ApplicationController
      protect_from_forgery prepend: true, with: :exception
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      rescue_from ActionController::ParameterMissing do
        render json: { errors: 'bad request' }, status: :bad_request
      end

      before_action :ensure_user_authorized

      private

      # авторизоваться через заголовок запроса
      def ensure_user_authorized
        token = request
                .headers.env.reject { |key| key.to_s.include?('.') }['QUERY_STRING']
                .delete_prefix('api_token=')

        @current_user = User.where.not(api_token: nil)
                            .find_by(api_token: token)

        head(:forbidden) unless @current_user
      end

      def success!(payload = {}, code = nil)
        code ||= :ok

        render json: { success: true, payload: payload }, status: code
      end

      def fail!(errors, code = nil)
        errors = [errors] if errors.is_a? String

        code ||= :unprocessable_entity

        render json: { success: false, errors: errors }, status: code
      end

      def not_found
        render json: { errors: 'record not found' }, status: :not_found
      end
    end
  end
end
