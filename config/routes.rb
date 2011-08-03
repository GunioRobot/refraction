Src2::Application.routes.draw do
  devise_for :users
  resources :tweets
  
  resources :tweets do
    resources :comments
  end
  
  resources :users do
    
  end
  
  resources :comments

  root :to => "home#index"
end
