class CreateBlacklistedJwts < ActiveRecord::Migration[7.0]
  def change
    create_table :blacklisted_jwts do |t|
      t.string :jti

      t.timestamps
    end
    add_index :blacklisted_jwts, :jti
  end
end
