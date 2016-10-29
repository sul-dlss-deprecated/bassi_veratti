BassiVeratti::Application.routes.draw do
  scope "(:locale)", :locale => /en|it/ do
    # Blacklight.add_routes(self)
    mount Blacklight::Engine => '/'
    root to: "catalog#index"
    concern :searchable, Blacklight::Routes::Searchable.new
    concern :exportable, Blacklight::Routes::Exportable.new

    resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
      concerns :searchable
    end

    resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
      concerns :exportable
    end

    resources :bookmarks do
      concerns :exportable

      collection do
        delete 'clear'
      end
    end

    match 'login',     :to => 'catalog#index', :as => 'new_user_session',       via: [:get, :post]
    match 'logout',    :to => 'catalog#index', :as => 'destroy_user_session',   via: [:get, :post]
    match 'account',   :to => 'catalog#index', :as => 'edit_user_registration', via: [:get, :post]
    get 'collections', :to => 'catalog#index', :as => 'collection_highlights'

    get 'version',     :to => 'about#show', :defaults => { :id => 'version' }, :as => 'version'

    # Handles all About pages.
    get 'about',         :to => 'about#show',    :as => 'about_project', :defaults => { :id => 'project' } # no page specified, go to project page
    match 'contact',     :to => 'about#contact', :as => 'contact_us', via: [:get, :post]
    get 'about/contact', :to => 'about#contact' # specific contact us about page
    get 'about/:id',     :to => 'about#show'    # catch anything else and direct to show page with ID parameter of partial to show

    # handle background page
    match 'background',  :to => 'about#background', :as => 'background', via: [:get, :post]

    # handle content inventory pages
    get 'inventory',     :to => 'inventory#index', :as => 'inventory'
    match 'inventory(/:action(/:id))(.:format)', :to => 'inventory#:action', via: [:get, :post]

    # helper routes to we can have a friendly URL for items and collections
    get 'item/:id',       :to => 'catalog#show', :as => 'item'
    get 'collection/:id', :to => 'catalog#show', :as => 'collection'

    post 'accept_terms', :to => 'application#accept_terms', :as => 'accept_terms'

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

    # See how all your routes lay out with "rake routes"
  end
end
