source 'https://rubygems.org'

gem 'rails', '~> 4.2'
gem 'blacklight', '~> 6.0'
gem 'blacklight-marc'
gem 'blacklight_range_limit', '~> 6.0'

gem 'protected_attributes' # allows attr_accessible in rails 4
gem 'google-analytics-rails'
gem 'eadsax', :git => "https://github.com/sul-dlss/eadsax.git"
gem 'kaminari'
gem 'okcomputer'

# Gems used only for assets:
# previously not required in production environments by default, now possibly required?

group :assets do
  gem 'sass-rails',   '>= 3.2.3'
  gem 'coffee-rails', '>= 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
  gem 'therubyracer', :platforms => :ruby
end

group :development do
  gem 'byebug'
  gem 'launchy'
end

group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
  gem 'rubocop'
  gem 'sqlite3'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'rspec', '~> 3.0'
  gem 'test-unit', :require => false
  gem 'coveralls', :require => false
end

group :staging, :production do
  gem 'mysql2', "~> 0.4"
end

group :deployment do
  gem 'dlss-capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger', '~> 0.2'
end

gem 'rest-client'
gem 'geocoder'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'sprockets'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'json'
gem 'honeybadger', '~> 2.0'
gem 'rsolr', '~> 1.0'
