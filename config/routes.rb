require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sk"

  resources :users, param: :username do
    resources :resumes do
      member do
        get 'delete'
      end
      resources :publications, module: 'resumes'
    end
  end

  resources :sessions, only: [:new, :create] do
    collection do
      get 'logout'
    end
  end

  resources :publications, param: :slug, only: [:show] do
    get 'not_found'
  end

  resources :support, only: [:index]

  # Static pages
  get "features" => "front#features"
  get "pricing" => "front#pricing"
  get "terms_of_service" => "front#terms_of_service"
  get "privacy_policy" => "front#privacy_policy"
  get "wallaby" => "front#wallaby"

  namespace :admin do
    resources :dashboards, only: [:index]
    resources :users, param: :username
    root to: "dashboards#index"
  end

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
