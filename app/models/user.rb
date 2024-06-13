class User < ApplicationRecord
    has_secure_password
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?

    def generate_jwt
        jti = SecureRandom.uuid
        payload = { user_id: id, jti: jti, exp: 24.hours.from_now.to_i }
        JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
      end

end
