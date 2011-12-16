Cartocs::Application.routes.draw do
  resources :datacenters, :except => :show
  resources :upgrades, :only => :index
  resources :companies do
    collection { get 'autocomplete' }
  end
  resources :contacts
  resources :backup_exceptions, :except => :show
  resources :backup_jobs, :only => [:index]
  resources :licenses
  resources :nss_disks, :only => [:index]
  resources :nss_volumes, :only => [:index]
  resources :cronjobs, :only => [:index]
  resources :configuration_items, :only => [:index, :show]
  resources :settings, :only => :index do
   collection { put 'update_all', :as => 'update_all' }
  end
  resources :saas, :only => :show
  resources :users, :except => :show do
    collection { get 'random_token' }
  end
  resources :physical_racks, :except => :show
  resources :sites, :except => :show
  resources :operating_systems, :except => :show
  resources :tomcats, :only => :index do
    collection { get 'index_old', :as => 'old' }
  end
  resources :databases do
    collection { get 'distribution' }
  end
  resources :storages
  resources :servers do
    collection { get 'maintenance' }
  end
  resources :applications

  put 'hide_announcement' => 'javascripts#hide_announcement', :as => 'hide_announcement' 

  get 'puppet(/:action(.:format))', :to => 'puppet', :as => 'puppet'
  get 'tools(/:action(/:id(.:format)))', :to => 'tools', :as => 'tool'

  match 'auth/:provider/callback' => 'sessions#create'
  match 'signout' => 'sessions#destroy', :as => :signout
  match 'auth/failure' => 'sessions#failure', :as => :auth_failure
  match 'auth/required' => 'sessions#unprotected', :as => :auth_required

  #get "welcome/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
