# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'rails', '~> 6.1.6', '>= 6.1.6.1'
# gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1'
gem 'jquery-rails'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'foreman', '~> 0.87.2'

# для проверки корректности введенного email
gem 'valid_email2', '~> 4.0'

# декораторы
gem 'draper', '~> 4.0'

# гем для разделения контента по страницам
gem 'pagy', '~> 5.10'

# Чтобы искать неоптимальные запросы и их устранять используется решение «bullet»
gem 'bullet', '~> 7'

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
gem 'sidekiq', '~> 6.5'

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
  gem 'vcr', '~> 6.1'
  gem 'webmock', '~> 3.14'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 3.0'
  gem 'rubocop', '~> 1.30', require: false
  gem 'rubocop-performance', '~> 1.14', require: false
  gem 'rubocop-rails', '~> 2.14', require: false
  gem 'rubocop-rspec', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # чтобы подгружать переменные в environment
  gem 'dotenv', '~> 2.7'
  gem 'dotenv-rails', '~> 2.7'
end

# Gemfile (очистить базу данных)
# https://github.com/DatabaseCleaner/database_cleaner
group :test do
  gem 'database_cleaner-active_record'
end

gem 'letter_opener', '~> 1.8'

gem 'recaptcha', '~> 5.12'

gem 'pundit', '~> 2.2'

gem 'faraday', '~> 2.5'

gem 'dry-transaction', '~> 0.14.0'

gem 'where_exists', '~> 2.0'

gem 'mailjet', '~> 1.7'

gem 'cssbundling-rails', '~> 1.0'
gem 'jsbundling-rails', '~> 1.0'
gem 'sprockets-rails', '~> 3.4'