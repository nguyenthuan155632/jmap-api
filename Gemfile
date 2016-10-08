source 'https://rubygems.org'

# test2
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.2'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.3.18'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Rails plugin to separate model concerns into multiple files.
# https://github.com/jakehow/concerned_with
gem 'concerned_with'
#Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible. (https://github.com/cyu/rack-cors)
gem 'rack-cors', '~> 0.4.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'multi_json', '1.7.8' 

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem "factory_girl_rails", "~> 4.0"
  gem 'guard-rspec'
  gem 'rspec-request_describer'
  gem 'autodoc'
  gem 'json_spec'
  gem 'database_cleaner'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
end