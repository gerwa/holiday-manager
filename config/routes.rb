Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  
  post 'visitors/testmail' => 'visitors#testmail'
  
  resources :users
end
