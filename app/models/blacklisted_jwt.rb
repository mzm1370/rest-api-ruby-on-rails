class BlacklistedJwt < ApplicationRecord
    validates :jti, presence: true, uniqueness: true
end
