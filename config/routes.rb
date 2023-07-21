# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[index show]
      post "contact", to: "contact#create"
    end
  end
end
