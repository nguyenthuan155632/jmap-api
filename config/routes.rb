Rails.application.config.relative_url_root = '/v1'
Rails.application.routes.draw do
  get 'inquiry/create'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

scope Rails.application.config.relative_url_root || '/', format: 'json' do

  get 'get_airports/' => 'get_airports#get_airports'
  post 'get_airports/' => 'get_airports#get_airports'
  match 'get_airports/' => 'get_airports#get_airports', :via => :post

  get 'inquiry/' => 'inquiry#create'
  post 'inquiry/' => 'inquiry#create'
  match 'inquiry/' => 'inquiry#create', :via => :post

  get 'get_lang/' => 'get_lang#get_lang'
  match 'get_lang/' => 'get_lang#get_lang', :via => :post

  # JB001
  post 'get_areas/' => 'get_areas#get_areas'
  match 'get_areas/' => 'get_areas#get_areas', :via => :post

  # JB002
  post 'find_buildings/' => 'find_buildings#find_buildings'
  match 'find_buildings/' => 'find_buildings#find_buildings', :via => :post

  # JB003
  post 'find_areas_buildings/' => 'find_areas_buildings#find_areas_buildings'
  match 'find_areas_buildings/' => 'find_areas_buildings#find_areas_buildings', :via => :post

  # JB004
  post 'find_buildings_with_radius/' => 'find_buildings_with_radius#find_buildings_with_radius'
  match 'find_buildings_with_radius/' => 'find_buildings_with_radius#find_buildings_with_radius', :via => :post

  # JB005
  post 'get_buildings_entrance_image_url/' => 'get_buildings_entrance_image_url#get_buildings_entrance_image_url'
  match 'get_buildings_entrance_image_url/' => 'get_buildings_entrance_image_url#get_buildings_entrance_image_url', :via => :post

  # JB006
  post 'get_indoor_map/' => 'get_indoor_map#get_indoor_map'
  match 'get_indoor_map/' => 'get_indoor_map#get_indoor_map', :via => :post

  # JB007
  post 'find_properties/' => 'find_properties#find_properties'
  match 'find_properties/' => 'find_properties#find_properties', :via => :post

  # JB008
  post 'find_entity/' => 'find_entity#find_entity'
  match 'find_entity/' => 'find_entity#find_entity', :via => :post

  # JB009-1
  post 'output_log/output_log_route_guidance' => 'output_log#output_log_route_guidance'
  match 'output_log/output_log_route_guidance' => 'output_log#output_log_route_guidance', :via => :post

  # JB009-2
  post 'output_log/output_log_chinese_concierge' => 'output_log#output_log_chinese_concierge'
  match 'output_log/output_log_chinese_concierge' => 'output_log#output_log_chinese_concierge', :via => :post

  # JB009-3
  post 'output_log/output_log_dfs_search' => 'output_log#output_log_dfs_search'
  match 'output_log/output_log_dfs_search' => 'output_log#output_log_dfs_search', :via => :post

  # 指定された条件に基づき、文章エンティティをを取得する
  match '/query' =>  'api#query', via: [:get, :post]

  # 指定された単語に対応する、指定された言語の単語を取得する
  match '/translate' =>  'api#translate', via: [:get, :post]

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
end
