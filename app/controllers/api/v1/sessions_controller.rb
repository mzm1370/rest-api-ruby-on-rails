# app/controllers/api/v1/sessions_controller.rb
module Api
    module V1
      class SessionsController < ApplicationController
        def create
          user = User.find_by(email: params[:email])
  
          if user&.authenticate(params[:password])
            token = user.generate_jwt
            render json: { token: token }, status: :ok
          else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        end
  
        def destroy
          auth_header = request.headers['Authorization']
          token = auth_header.split(' ').last if auth_header.present? && auth_header.start_with?('Bearer ')
  
          if token.present?
            begin
              decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
              jti = decoded_token[0]['jti']
              $redis.sadd('blacklisted_jwts', token)
              render json: { message: 'Logged out successfully' }, status: :ok
            rescue JWT::DecodeError
              render json: { error: 'Invalid token' }, status: :unauthorized
            end
          else
            render json: { error: 'Token not provided' }, status: :unauthorized
          end
        end
      end
    end
  end

  
  