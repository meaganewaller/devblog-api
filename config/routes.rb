# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :posts, only: %i[index show]
      resources :categories, only: %i[index show]
      resources :projects, only: %i[index show]
      post "contact", to: "contact#create"
    end
  end
end
