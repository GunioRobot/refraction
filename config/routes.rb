Src2::Application.routes.draw do
  devise_for :users
  #devise_for :visitors
  resources :tweets
  
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
    
    resources :tweets, :only=>[:index, :destroy]
    resources :comments, :only=>[:index, :destroy]
    resources :logs, :only=>[:index]
    resources :sites do
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
  
  post 'circle'=>'sites#circle'

  root :to => "home#index"
end
