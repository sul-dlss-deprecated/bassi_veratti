source 'https://rubygems.org'

gem 'bundler', '>= 1.2.0'

gem 'rails', '~> 3.2.22'

gem 'google-analytics-rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "blacklight", '~> 4.0'
gem "blacklight_range_limit"
gem 'eadsax', :git => "https://github.com/sul-dlss/eadsax.git"
gem 'kaminari', '<= 0.14.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
end

group :development do
	gem 'better_errors'
	gem 'meta_request'
	gem 'launchy'
end

group :development, :test do
  gem 'jettywrapper'
  gem 'sqlite3'
  gem 'test-unit', :require => false
end

group :staging, :production do
  gem 'mysql2', "~> 0.3.10"
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'lyberteam-capistrano-devel'
end

gem 'rest-client'
gem 'geocoder'
gem 'jquery-rails'

gem "bootstrap-sass"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'json', '~> 1.8.0'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'debugger'
