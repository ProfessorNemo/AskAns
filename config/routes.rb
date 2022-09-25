# frozen_string_literal: true

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
  resources :hashtags, only: %i[show], param: :text

  namespace :api do
    resources :hashtags, only: :index

    resources :users, only: :index
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
    # #
    # Для любознательных: синонимы мы добавили, чтобы показать одну вещь и потом
    # их удалим.
    # get 'sign_up' => 'users#new'
    # get 'log_out' => 'sessions#destroy'
    # get 'log_in' => 'sessions#new'
  end
end
