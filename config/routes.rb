Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  
  post 'visitors/testmail' => 'visitors#testmail'
  
  get 'event_registrations/registrations_list' => 'event_registrations#registrations_list'
  get 'event_registrations/overview' => 'event_registrations#overview'
  get 'users/changepw' => 'users#changepw'
    
  resources :users
  resources :event_registrations
  resources :people
  resources :prices
  resources :meals
  resources :events
  resources :payments
  
  
end
