redis_config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]

Sidekiq.configure_server do |config|  
  config.redis = { :url => "redis://#{redis_config[:host]}:#{redis_config[:port]}/#{redis_config[:db]}", :namespace => 'green', :size => 25 }
end

Sidekiq.configure_client do |config|  
  config.redis = { :url => "redis://#{redis_config[:host]}:#{redis_config[:port]}/#{redis_config[:db]}", :namespace => 'green', :size => 25 }
end