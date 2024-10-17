# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  default_url_options host: ENV["HOST_URL"]
  Healthcheck.routes(self)
  mount GoodJob::Engine => "good_job"

  namespace :admin do
    %i[
      guestbook_entries
      posts
      categories
      views
    ].each do |name|
      resources name, only: %i[index show new create edit update destroy]
    end

    root to: "posts#index"
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :posts, only: %i[index show]
      resources :categories, only: %i[index show]
      resources :guestbook_entries, only: %i[index create destroy], path: :guestbook
      resources :views, only: %i[index create]
      post "contact", to: "contact#create"
    end
  end
end
