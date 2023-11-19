# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  mount GoodJob::Engine => "good_job"
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :posts, only: %i[index show update] do
        resources :reactions, only: %i[index show create], controller: "post_reactions"
      end
      resources :categories, only: %i[index show]
      resources :projects, only: %i[index show]
      resources :views, only: %i[index create]
      post "contact", to: "contact#create"
      resource :post_comments, only: %i[create]
    end
  end
end
