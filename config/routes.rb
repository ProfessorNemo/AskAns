# frozen_string_literal: true

Rails.application.routes.draw do
  resources :sessions, only: %i[new create destroy]

  resources :users

  # Со страницы юзера будет отправляться форма на создание вопроса
  resources :questions, except: %i[show new index]

  root 'users#index'

  # Синонимы путей — в дополнение к созданным в ресурсах выше.
  #
  # Для любознательных: синонимы мы добавили, чтобы показать одну вещь и потом
  # их удалим.
  get 'sign_up' => 'users#new'
  get 'log_out' => 'sessions#destroy'
  get 'log_in' => 'sessions#new'
end
