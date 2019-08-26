source 'https://rubygems.org'

gem 'bundler', '>= 1.2.0'
gem 'rails', '~> 4'
gem 'protected_attributes' # allows attr_accessible in rails 4
gem 'google-analytics-rails'

gem "blacklight", '~> 4.0'
gem 'blacklight_range_limit', '~> 2.3.0'
gem 'eadsax', :git => "https://github.com/sul-dlss/eadsax.git"
gem 'kaminari', '<= 0.14.1' # blacklight also sets semver, so we don't end up w/ 0.0.0
gem 'okcomputer'

# Gems used only for assets:
# previously not required in production environments by default, now possibly required?

group :assets do
  gem 'sass-rails',   '>= 3.2.3', '< 6'
  gem 'coffee-rails', '>= 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
  gem 'therubyracer', :platforms => :ruby
end

group :development do
  gem 'transpec'
  gem 'byebug'
end

group :development, :test do
  gem 'solr_wrapper', '~> 2.0'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'sqlite3', '~> 1.3.13'
  gem 'capybara', '~> 3.15.0' # pinned for ruby 2.3 compatibility
  gem 'rspec-rails'
  gem 'rspec', '~> 3.0'
  gem 'test-unit', :require => false
  gem 'simplecov', :require => false
end

group :staging, :production do
  gem 'mysql2', "~> 0.3.10"
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
gem 'sprockets-rails'
gem 'json', '~> 1.8.0'
gem 'honeybadger', '~> 2.0'
