# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.6', '>= 6.1.6.1'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'
# gem 'jbuilder', '~> 2.7'
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

gem 'rails-i18n', '~> 7.0.3'

# в json. Сериализатор работает быстрее, чем 'jbuilder', '~> 2.11'
gem 'blueprinter'

# Импорт данных из .xlsx в БД
gem 'roo', '~> 2.9.0'

# Иконки флагов стран
gem 'flag-css-rails'
gem 'flag-icons-rails'
# основной гем с иконками флагов
gem 'famfamfam_flags_rails'

group :development, :test do
  gem 'byebug'
  gem 'faker', '~> 2'
  gem 'pry-rails'
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
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # чтобы подгружать переменные в environment
  gem 'dotenv', '~> 2.7'
end

# Gemfile (очистить базу данных)
# https://github.com/DatabaseCleaner/database_cleaner
group :test do
  gem 'database_cleaner-active_record'
end
