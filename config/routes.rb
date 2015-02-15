require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/__kickside"

  scope '/app' do
    resources :users, param: :username, except: [:index, :destroy] do
      resources :resumes do
        member do
          get "delete"
          get "stats" => "resume_stats#index"
        end
      end
    end

    get '/app/confirm' => "signup_confirmations#update"

    resources :sessions, only: [:new, :create] do
      collection do
        get "logout"
      end
    end

    namespace :admin do
      resources :dashboards, only: [:index]
      resources :users, param: :username
      root to: "dashboards#index"
    end
  end

  scope '/pages' do
    resources :support, only: [:index]

    # Static pages
    get "features" => "front#features"
    get "get_started" => "front#get_started"
    get "pricing" => "front#pricing"
    get "terms_of_service" => "front#terms_of_service"
    get "privacy_policy" => "front#privacy_policy"
  end

  get "wallaby" => "front#wallaby"

  get "/:slug" => "publications#show", as: "publication"

  root "front#index"
end
