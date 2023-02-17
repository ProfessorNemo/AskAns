# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

gem 'bcrypt', '~> 3.1'
gem 'jquery-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'rails', '~> 6.1.6', '>= 6.1.6.1'
gem 'turbolinks', '~> 5'

# для проверки корректности введенного email
gem 'valid_email2', '~> 4.0'

# декораторы
gem 'draper', '~> 4.0'

# гем для разделения контента по страницам
gem 'pagy', '~> 5.10'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# решение, которое позволяет импортировать в БД множество записей за один запрос
gem 'activerecord-import', '~> 1.4'

# решение, которое позволяет работать с файлами .xlsx (но только записывать, т.е. создавать)
gem 'caxlsx', '~> 3.2'
# Позволяет работать с представлениями
gem 'caxlsx_rails', '~> 0.6'

gem 'rails-i18n', '~> 7.0.3'

# в json. Сериализатор работает быстрее, чем 'jbuilder', '~> 2.11'
gem 'blueprinter'
gem 'oj'

# Импорт данных из .xlsx в БД
gem 'roo', '~> 2.9.0'

# Решение, которое позволяет работать с архивами .zip
gem 'rubyzip', '~> 2.3'

# Решение, которое позволяет считывать и модифицировать файлы .xlsx
gem 'rubyXL', '~> 3.4'

# адаптер для выполнения задач в фоновом режиме
gem 'sidekiq'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'faker', '~> 2'
  gem 'pry-rails'
  gem 'pundit-matchers', '~> 1.7.0'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '>= 5.1.2'
  gem 'shoulda-matchers'
end

group :test do
  gem 'action_mailer_matchers'
  gem 'rspec', '~> 3.11'
  gem 'rspec-sidekiq'
  gem 'vcr', '~> 6.1'
  gem 'webmock', '~> 3.14'
end

group :development do
  gem 'dotenv', '~> 2.7'
  gem 'dotenv-rails', '~> 2.7'
  gem 'listen', '~> 3.3'
  gem 'rubocop', '~> 1.30', require: false
  gem 'rubocop-performance', '~> 1.14', require: false
  gem 'rubocop-rails', '~> 2.14', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console', '>= 4.1.0'
end

gem 'active_storage_validations'
gem 'activestorage-validator'
gem 'aws-sdk-s3'
gem 'cssbundling-rails', '~> 1.0'
gem 'dry-transaction', '~> 0.14.0'
gem 'faraday', '~> 2.5'
gem 'image_processing', '~> 1.2'
gem 'impressionist'
gem 'jsbundling-rails', '~> 1.0'
gem 'letter_opener', '~> 1.8'
gem 'mailjet', '~> 1.7'
gem 'pundit', '~> 2.2'
gem 'recaptcha', '~> 5.12'
gem 'sprockets-rails', '~> 3.4'
gem 'where_exists', '~> 2.0'

gem 'httparty', '~> 0.21.0'
