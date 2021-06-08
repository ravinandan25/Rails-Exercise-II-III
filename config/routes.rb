Rails.application.routes.draw do  
  root 'home#index'
  resources :users
  resources :sessions, only: %i[new create destroy]
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
end
