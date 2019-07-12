Rails.application.routes.draw do
  root 'static_pages#home'
  get 'help', 		to: 'static_pages#help'
  get 'contact', 	to: 'static_pages#contact'
  get 'signup', 	to: 'users#new'
  get    'login', to: 'sessions#new'
  post   'login', to: 'sessions#create'
  delete 'logout',to: 'sessions#destroy'
  get 'create',   to: 'events#new'
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :events
end
