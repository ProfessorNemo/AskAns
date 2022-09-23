# frozen_string_literal: true

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

    namespace :admin do
      resources :users, only: %i[index create show destroy]
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
