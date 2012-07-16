Redis.current = $redis = Redis.new(YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env])
require 'redis/objects'