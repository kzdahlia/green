# install Redis

`brew install redis`

# setup project

`cp config/redis.yml.exmaple config/redis.yml`  
`cp config/omniauth.yml.exmaple config/omniauth.yml`

# start redis

`redis-server /usr/local/etc/redis.conf`

# start project

`rails s`

# rebuild

`bundle exec rake dev:rebuild`