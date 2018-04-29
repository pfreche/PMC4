PMC4::Application.routes.draw do

  get 'config/show' => 'config#show', as: 'show_config'

  get 'scanners/scan' => 'scanners#scan', as: 'scan_scanners'
  get 'scanners/match' => 'scanners#match', as: 'match_scanners'
  post 'scanners/match' => 'scanners#match', as: 'match_scanners_post'

  get 'scanners/msas' => 'scanners#msas', as: 'msas_scanners'
  get 'scanners/msytdl' => 'scanners#msytdl', as: 'msytdl_scanners' # youtube dl


#
  resources :scanners do
#    get 'match', :on => :collection
    get 'copy', :on => :member
    get 'scann', :on => :member
    get 'extract', :on => :member
    get 'extractsave', :on => :member
  end

  resources :bookmarks do
    get 'getTitle', :on => :member
    get 'scan', :on => :member
    post 'search', :on => :collection
    get 'linkFolder', :on => :member
  end

  resources :mtypes


  resources :matches do
    get 'match', :on => :collection
    get 'extract', :on => :member
    get 'extractsave', :on => :member

  end

  resources :regurls do

    get 'check', :on => :member
    get 'match', :on => :collection

  end


  resources :agroups
  patch 'agroups' => 'agroups#indexedit', as: 'indexedit_agroups'

  get 'attris/find' => 'attris#find', as: 'find_attris'
  get 'attris/indi' => 'attris#indi', as: 'indi_attris'
  get 'attris/:id/find' => 'attris#find', as: 'find_attris2'

  get 'uris/show'  => "uris#show", as: 'uris_show'
  get 'uris/matchURL'  => "uris#matchURL", as: 'matchURL_uris'
  get 'uris/matchDir'  => "uris#matchDir", as: 'uris_matchDir'

  get 'uris/fetch'  => "uris#fetch", as: 'fetch_uris'
  get 'uris/save'  => "uris#save", as: 'save_uris'

  get 'uris/getLinks'  => "uris#getLinks", as: 'getLinks_uris'

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
    get 'youtubeLink', :on => :member
    get 'renderMfile', :on => :member
    get  'classify', :on => :collection
    get  'slideshow', :on => :collection
    post 'set_attris', :on => :collection
    get  'thumbs', :on => :collection
    get 'download', :on => :member
  end

  resources :folders do
    post 'copyFiles', :on => :member
    post 'generateTNs', :on => :member
    get 'changeStorage', :on => :member
    post 'checkForVideoFiles', :on => :member

  end




  patch 'folders' => 'folders#indexedit', as: 'indexedit_folders'

  resources :locations do
    get 'analyzeFiles', :on => :member
    get 'deleteFiles', :on => :member
    get 'copyToFiles', :on => :member
    get 'downloadToFiles', :on => :member
    get 'parse', :on => :member
    get 'getTitle', :on => :member
    post 'gswl', :on => :member
    get 'checkAvail', :on => :member
    get 'parseURL', :on => :member
    get 'scan', :on => :member
    get 'ls', :on => :member
  end

  resources :storages do
    get 'detectfolders', :on => :member
    get 'detectfiles', :on => :member
    get 'detectFaFs', :on => :member
    get 'make_thumbnails', :on => :member
    post 'touchMfiles', :on => :member
    post 'generateTNs', :on => :member
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
