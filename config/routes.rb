# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]

  resources :users, only: %i[show new create edit update index]
  resources :questions

  root 'users#index'
end
