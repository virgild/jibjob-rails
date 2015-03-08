require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => ENV['SIDEKIQ_WEB_MOUNT']

  scope '/app' do
    resources :users, param: :username, except: [:index] do
      member do
        get 'delete'
      end
      resources :resumes do
        member do
          get 'delete'
          get 'stats' => 'resume_stats#index'
          get 'stats/:year/:month/:day/:hour' => 'resume_stats#hour_views', as: 'hour_views'
        end
      end
    end

    get '/confirm' => 'signup_confirmations#update'

    get '/reset_password' => 'password_recovery#index'
    post '/reset_password' => 'password_recovery#create'
    get '/new_password' => 'password_recovery#edit'
    post '/new_password' => 'password_recovery#update'

    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#logout'
    get '/signup' => 'users#new'
    post '/signup' => 'users#create'

    namespace :admin do
      resources :dashboards, only: [:index]
      resources :users, param: :username
      root to: "dashboards#index"
    end
  end

  scope '/pages' do
    resources :support, only: [:index]

    # Static pages
    get 'get_started' => 'front#get_started'
    get 'about' => 'front#about'
    get 'terms_of_service' => 'front#terms_of_service'
    get 'privacy_policy' => 'front#privacy_policy'
    get 'faq' => 'front#faq'
  end

  get '/:slug' => 'publications#show', as: 'publication'
  get '/:slug/access_code' => 'publications#access_code', as: 'publication_access_code'
  post '/:slug/access_code' => 'publications#post_access_code', as: 'publication_post_access_code'

  root 'front#index'
end
