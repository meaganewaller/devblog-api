# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  Healthcheck.routes(self)
  mount GoodJob::Engine => 'good_job'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :posts, only: %i[index show update] do
        resources :reactions, only: %i[index show create], controller: 'post_reactions'
        resources :comments, only: %i[index create]
      end
      resources :categories, only: %i[index show]
      resources :tags, only: %i[index]
      resources :projects, only: %i[index show] do
        resources :comments, only: %i[index create]
      end
      resources :workspaces, only: %i[index show] do
        resources :comments, only: %i[index create]
      end
      resources :views, only: %i[index create]
      post 'contact', to: 'contact#create'

      resources :comments, only: %i[show update destroy]
    end
  end
end
