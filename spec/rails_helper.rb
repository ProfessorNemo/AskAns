# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'
require 'byebug'
require 'dotenv/load'
require 'pundit/rspec'
require 'active_storage_validations/matchers'
require_relative './helpers/main'
require 'webmock/rspec'
require_relative './support/factory_bot'
require_relative './support/vcr'

require 'rails-i18n'
require 'action_mailer_matchers'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Загрузка любых файлов из директории support
# Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Pundit::Matchers.configure do |config|
  config.user_alias = :account
end

RSpec.configure do |config|
  config.include ActiveStorageValidations::Matchers

  config.include ActionMailerMatchers

  config.example_status_persistence_file_path = 'spec/specs.txt'

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Разрешаем делать подключения к реальным сервисам
  WebMock.allow_net_connect!
  # WebMock.disable_net_connect!(allow_localhost: true)

  WebMock::API.prepend(Module.new do
    extend self
    # disable VCR when a WebMock stub is created
    # for clearer spec failure messaging
    def stub_request(*args)
      # Выключаем VCR в тех случаях, когда работает WebMock и наоборот
      VCR.turn_off!
      super
    end
  end)

  config.before { VCR.turn_on! }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
