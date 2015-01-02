PMC4::Application.routes.draw do
  resources :media_types

  resources :agroups
  patch 'agroups' => 'agroups#indexedit', as: 'indexedit_agroups'
  

  get 'attris/find' => 'attris#find', as: 'find_attris'
  get 'attris/indi' => 'attris#indi', as: 'indi_attris'
  get 'attris/:id/find' => 'attris#find', as: 'find_attris2'

  resources :attris do
    get 'autocomplete', :on => :collection
    get 'overview', :on => :collection
  end
  
  resources :mfiles do
       post 'add_attri_name', :on => :member
       post 'add_attri', :on => :member
    delete 'remove_attri', :on => :member
    post 'add_agroup', :on => :member
    delete 'remove_agroup', :on => :member
    get 'edit0', :on => :member
    get 'new_tag', :on => :member
    get 'update_tag', :on => :member
    get 'delete_tag', :on => :member
    get 'pic', :on => :member
    get 'path', :on => :member
    get 'renderMfile', :on => :member
    get  'classify', :on => :collection
    get  'slideshow', :on => :collection
    post 'set_attris', :on => :collection
    get  'thumbs', :on => :collection   
  end

  resources :folders
  patch 'folders' => 'folders#indexedit', as: 'indexedit_folders'

  resources :locations

  resources :storages do
    get 'detectfolders', :on => :member
    get 'detectfiles', :on => :member
    get 'make_thumbnails', :on => :member
  end

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
