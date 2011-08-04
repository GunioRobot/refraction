Src2::Application.routes.draw do
  devise_for :users
  devise_for :visitors
  resources :tweets
  
  resources :tweets do
    resources :comments
  end
  
  resources :users do
    
  end
  
  resources :comments

  root :to => "home#index"
end
