# frozen_string_literal: true

require 'sidekiq/web'

# класс "Ограничение". М-д "matches" принимает запрос, который был отправлен
# на адрес '/admin/users'. Приходит на этот адрес запрос, перенаправлем в AdminConstraint
# проверку, читаем запрос, смотрим, от кого он и решаем: пускать или нет.
# "user_id" - помещен либо в сессию, либо в зашифрованные куки если юзер поставил галочку
# "запомнить меня" (см. authentication.rb)
# request.cookie_jar.encrypted[:user_id] - дешифровка куки
class AdminConstraint
  def matches?(request)
    user_id = request.session[:user_id] || request.cookie_jar.encrypted[:user_id]
    # является ли найденный юзер админом (если юзер найден)
    User.find_by(id: user_id)&.admin_role?
  end
end

Rails.application.routes.draw do
  # Смонтировать маршрут Sidekiq::Web , по какому адресу он будет доступен ('/sidekiq'),
  # т.е. подрубаем интерфейс sidekiq по адресу '/sidekiq' (https://127.0.0.1:3000/sidekiq)
  # mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  mount Sidekiq::Web => '/sidekiq'

  resources :hashtags, only: :show, param: :text

  # API V1 (версия 1) routes
  namespace :api do
    namespace :v1 do
      resources :users, only: [], param: :username do
        resources :questions, only: :index
      end

      resources :hashtags, only: :index
      resources :users, only: :index
    end
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    # Для любого юзера будет только одна сессия регистрации (!)
    resource :session, only: %i[new create destroy]

    resources :users

    resource :password_reset, only: %i[new create edit update]

    # Со страницы юзера будет отправляться форма на создание вопроса
    resources :questions, except: %i[show new]

    root 'users#index'

    # не будет существовать тогда маршрута для всех, кроме админа. Закрывается
    # доступ к пространству маршрутов admin
    namespace :admin do
      constraints(AdminConstraint.new) do
        resources :users, except: %i[new]
      end
    end

    # Синонимы путей — в дополнение к созданным в ресурсах выше.
    # get 'sign_up' => 'users#new'
    # get 'log_out' => 'sessions#destroy'
    # get 'log_in' => 'sessions#new'
  end
end
