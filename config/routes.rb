Collabio::Application.routes.draw do
  resources :scenes

  resources :projects

  resources :videos do
    member do
      get :vote_up
      get :vote_down
      post :add_comment
    end
  end

  devise_for :users

  resources :users

  authenticated :user do
    root :to => 'pages#home'
  end

  root :to => 'pages#landing'

  match 'home' => 'projects#latest'
  match "about" => 'pages#about'
  match "contact" => 'pages#contact'
  match "terms" => 'pages#terms'
  match "privacy" => 'pages#privacy'

  match 'mockscene1' => 'pages#mockscene1'
  match 'mockscene2' => 'pages#mockscene2'
  match 'mockvote' => 'pages#mockvote'
  match 'mocksubmit' => 'pages#mocksubmit'
  match 'mocknone' => 'pages#mocknone'

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
