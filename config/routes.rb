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
    get 'site_config'=>'site#index', :as=>:site_config
    post 'site_config/update'=>'site#update_site'
    put 'site_config/update'=>'site#update_site'
    get 'site_config/regenerate_keys' => 'site#regenerate_keys', :as=>:regenerate_keys
    
  end

  root :to => "home#index"
end
