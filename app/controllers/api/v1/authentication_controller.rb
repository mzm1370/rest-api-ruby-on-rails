module Api
    module V1
      class AuthenticationController < ApplicationController
        def authenticate
          
          user = User.find_by(email: params[:email])
          puts "User: #{user.inspect}"
          if user&.authenticate(params[:password])
            token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
            render json: { token: token }, status: :ok
          else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        end
      end
    end
  end