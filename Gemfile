source 'https://rubygems.org'
ruby '2.1.8'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'
gem 'bcrypt-ruby', '3.1.2' 
gem 'shoulda-matchers'
gem 'fabrication'
gem 'sidekiq'
gem 'foreman'
gem 'unicorn'
gem "sentry-raven" 

# Resque for scheduling
gem 'resque', '~> 1.25.2'
gem 'resque-scheduler', '~> 4.0.0'
gem 'resque-web', require: 'resque_web'
gem 'resque-scheduler-web'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'faker'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'redis'
end

