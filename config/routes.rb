# frozen_string_literal: true

Rails.application.routes.draw do
  resource :users, only: %i[show]
end
