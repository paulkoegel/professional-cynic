source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '~> 3.2'
gem 'pg'
gem 'thin'

gem 'sorcery'
gem 'settingslogic'

gem 'rabl' # must appear before 'gon'
gem 'oj' # required for RABL
gem 'gon'
gem 'dropbox-api'#, :git => 'git@github.com:paulwittmann/dropbox-api.git'
gem 'haml-rails'
gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'animation' # CSS3 animations plugin for compass
  gem 'coffee-rails', '~> 3.2'
  gem 'compass-normalize'
  gem 'compass-rails'
  gem 'execjs'
  gem 'haml_coffee_assets'
  gem 'oily_png' # faster CSS sprite generation
  gem 'sass', '~> 3.2'
  gem 'sass-rails', '~> 3.2'
  gem 'uglifier', '>= 1.2.6'
end

group :development do
  gem 'dimensions' # pure Ruby implementation to retrieve image files' dimension
  #gem 'lograge'
  gem 'quiet_assets'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller' # required for better_errors
end

group :development, :test do
  gem 'factory_girl_rails', '>= 1.1.rc1', require: false
  gem 'guard-jasmine'
  gem 'jasminerice'
  gem 'pry-debugger'
  gem 'rspec'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '>= 1.1.rc1', require: false
  gem 'fuubar', '~> 1.0.0'
  gem 'launchy'
  gem 'rspec-instafail'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'turn', '~> 0.8.3', require: false
end
