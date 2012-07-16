namespace :dev do

  desc "Rebuild from schema.rb"
  task :build => ["tmp:clear", "log:clear", "db:reset", "db:setup", "dev:fake"]

  desc "Rebuild from migrations"
  task :rebuild => ["tmp:clear", "log:clear", "db:drop", "db:create", "db:migrate", "dev:fake"]

  desc "Generate fake data"
  task :fake => :environment do
  end
  
end