DinnerAdviser::Application.routes.draw do

  devise_for :users

  resources :products do
    member do
      put :set_availability
      put :add_or_remove_to_shopping_list
    end
    collection do
      get :import_common, action: :list_common
      post :import_common, action: :import_common
    end
  end
  
  resources :courses do
    member do
      put :add_or_remove_to_menu
    end
    collection do
      get :import_common, action: :list_common
      post :import_common, action: :import_common
    end
  end

  resources :menus do
    member do
      get :products
    end
  end

  resources :shopping_lists

  resources :categories
  resources :product_categories, controller: 'categories', type: 'ProductCategory' 
  resources :menu_categories, controller: 'categories', type: 'MenuCategory'
  resources :course_categories, controller: 'categories', type: 'CourseCategory'

  namespace :admin do
    root :to => "admin#index"
    resources :products
    resources :courses
  end

  resource :introduction, controller: 'introduction' do
    collection do
      get :next_step
      get :list_common_products
      post :import_products
      get :list_common_courses
      post :import_courses
    end
  end

  root 'static_pages#home'

  get 'advice', to: 'advices#random_course'
  get 'advice(/:course_id)', to: 'advices#random_course'
  #match '/advice',    to: 'advices#random_course', via: 'get'
  #match '/advice/:course_id',    to: 'advices#random_course', via: 'get'

  get '/about',    to: 'static_pages#about'
  get '/contact',    to: 'static_pages#contact'


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
