# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandling
  include Authentication
  include OtherChecks
  include Internationalization
  include Pagy::Backend

  # Prevent CSRF attacks by raising an exception.
  #
  # Эта строчка вызывает метод, который обеспечивает защиту от поддельных форм
  # в каждой форме есть специальный уникальный токен, который rails-приложение
  # сгенерировало специально для этой формы и который нужно отправить вместе
  # с запросом, чтобы сервер его принял.
  #
  # http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf
  protect_from_forgery with: :exception
end
