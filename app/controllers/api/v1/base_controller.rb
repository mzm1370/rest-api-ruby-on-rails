module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      private

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        if token.present?
          if Redis.current.sismember('blacklisted_jwts', token)
            render json: { error: 'Token is blacklisted' }, status: :unauthorized
          else
            begin
              payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
              @current_user = User.find(payload['user_id'])
            rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
              render json: { error: 'Invalid token' }, status: :unauthorized
            end
          end
        else
          render json: { error: 'Token not provided' }, status: :unauthorized
        end
      end

      def current_user
        @current_user
      end
    end
  end
end



