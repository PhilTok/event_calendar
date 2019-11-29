Rails.application.routes.draw do
  root 'static_pages#home'
  get 'signup', 	to: 'users#new'
  get    'login', to: 'sessions#new'
  post   'login', to: 'sessions#create'
  delete 'logout',to: 'sessions#destroy'
  get 'create',   to: 'events#new'
  post '/' => 'events#my_events', as: 'my_events'
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :events
end
