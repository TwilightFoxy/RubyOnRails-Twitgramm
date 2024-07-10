source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.8"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'bcrypt', '~> 3.1.7'
gem 'devise'
gem 'toastr-rails'
gem 'pundit'
gem 'bootstrap'
gem 'image_processing'
gem 'mini_magick'
gem 'pg'
gem 'mini_racer', platforms: :ruby

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
end

gem 'rails-controller-testing'
