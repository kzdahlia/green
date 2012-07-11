# install Redis

`brew install redis`

# setup project

`cp config/redis.yml.exmaple config/redis.yml`  
`cp config/omniauth.yml.exmaple config/omniauth.yml`

# start redis

`redis-server /usr/local/etc/redis.conf`

# 啟動背景作業

`bundle exec sidekiq -c 1`  

必須在 `rails s` 以前執行

# start project

`rails s`

# rebuild

`bundle exec rake dev:rebuild`

