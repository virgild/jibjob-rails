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
    get "wallaby" => "front#wallaby"
  end


  get "/:slug" => "publications#show", as: "publication", slug: /[A-Za-z0-9-]+/

  root "front#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
