require 'redis'

$redis = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6380/0")
