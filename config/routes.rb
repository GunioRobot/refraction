Src2::Application.routes.draw do
  devise_for :users
  #devise_for :visitors
  resources :tweets do
    member do
    get :comments_counter
    
    end
    collection do
      get :remote_comments_counter
    end
  end
  
  resources :tweets do
    resources :comments
  end
  
  resources :users do
    
  end
  
  resources :comments, :except=>[:show]
  
  namespace :admin do
    get '/' =>'dashboard#show', :as=>:dashboard
    resources :users do
      member do
        get 'tweets'
        get 'comments'
        post 'addroles'
        post 'removeroles'
        post 'resetroles'
        delete 'removerole'
      end
    end
    
    resources :circles do
      collection do
        post 'add_sites_to_circles'
        post 'add_users_to_circles'
      end
    end
    resources :tweets, :only=>[:index, :destroy, :show]
    resources :comments, :only=>[:index, :destroy]
    resources :logs, :only=>[:index]
    resources :sites do
      member do
        post 'add_circles_to_site'
        delete 'remove_circle_from_site', :as=>'remove_circle_from_site'
      end
      collection do
        get 'circled_you', :as=>'circled_you'
        get 'you_circled', :as=>'you_circled'
        get 'circled_each_other', :as=>'circled_each_other'        
      end
  end
    
    get 'site_config'=>'site#index', :as=>:site_config
    post 'site_config/update'=>'site#update_site'
    put 'site_config/update'=>'site#update_site'
    get 'site_config/regenerate_keys' => 'site#regenerate_keys', :as=>:regenerate_keys
    
  end
  
  namespace :api do
    post 'circle'=>'sites#circle'
    get 'site_name'=>'sites#name'
    get 'site_email'=>'sites#email'
    get 'site_base_uri'=>'sites#base_uri'
    
    resources :sites
    
    resources :tweets do
      collection do
        post 'prerequest'
      end
    end
  end
  

  root :to => "home#index"
end
