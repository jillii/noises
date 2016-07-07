Rails.application.routes.draw do

  get 'user_mailers/new'

  root to: 'welcome#hi'

  # main page
  get 'mixes/all' => 'mixes#all'

  # custom controls for remixing existing track
  get 'mixes/:mix_id/mixes/new' => 'mixes#new_mix'
  post 'mixes/:mix_id/mixes' => 'mixes#create_mix'
  
  # use custom user registration (includes name field)
  devise_for :users, :controllers => { registrations: 'registrations' }
  
  resources :users do
    resources :mixes
    resources :notifications
  end
  
  resources :mixes do
    resources :mixes
  end

  # for downloads
  resources :mixes do
    member { get :download }
  end
  # mailer
  resources :contacts, only: [:index, :new, :create]
  resources :user_mailers, only: [:index, :new, :create]
end