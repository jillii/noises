Rails.application.routes.draw do

  root to: 'mixes#all'

  # custom controls for remixing existing track
  get 'mix/:mix_id/mixes/new' => 'mixes#new_mix'
  post 'mix/:mix_id/mixes' => 'mixes#create_mix'
  
  # use custom user registration (includes name field)
  devise_for :users, :controllers => { registrations: 'registrations' }
  
  resources :users do
    resources :mixes
  end
  
  resources :mixes do
    resources :mixes
  end

  # for downloads
  resources :mixes do
    member { get :download }
  end
end