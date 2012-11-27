Cartoque::Application.routes.draw do
  resources :postits, except: [:index, :show]
  resources :upgrade_exclusions, except: :show
  resources :components
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :mailing_lists, except: :show
  resources :roles, except: :show do
    collection { post 'sort' }
  end
  resources :datacenters, except: :show
  resources :upgrades, only: :index do
    member { put 'validate' }
  end
  resources :companies do
    collection { get 'autocomplete' }
  end
  resources :contacts do
    collection { get 'autocomplete' }
  end
  resources :backup_exclusions, except: :show
  resources :backup_jobs, only: [:index]
  resources :licenses
  resources :cronjobs, only: [:index]
  resources :settings, only: :index do
   collection { put 'update_all', as: 'update_all' }
   collection { get 'edit_visibility'; put 'update_visibility' }
  end
  resources :saas, only: :show
  resources :users, except: :show do
    collection { get 'random_token' }
  end
  resources :physical_racks, except: :show
  resources :sites, except: :show
  resources :operating_systems
  resources :tomcats, only: [:index, :show]
  resources :databases do
    collection { get 'distribution' }
  end
  resources :storages
  resources :servers do
    collection { get 'maintenance' }
  end
  resources :applications

  # Plugins/engines
  Dir.glob(File.expand_path("../../vendor/plugins/*/config/routes.rb",__FILE__)).each do |routefile|
    engine_name = routefile.gsub("/config/routes.rb", "").gsub(%r{.*/vendor/plugins/}, "")
    engine = "#{engine_name.camelize}::Engine".constantize rescue nil
    #$stderr.puts "Mounting engine '#{engine}' to path '/#{engine_name}"
    mount engine => "/#{engine_name}" unless engine.nil?
  end

  put 'hide_announcement' => 'javascripts#hide_announcement', as: 'hide_announcement' 

  get 'puppet(/:action(.:format))', to: 'puppet', as: 'puppet'

  #get "welcome/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # This route can be invoked with purchase_url(id: product.id)

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
  #       get 'recent', on: :collection
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
  root to: "welcome#index"

  # catch ActionController#RoutingError
  match '*a', to: 'Application#render_404'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
