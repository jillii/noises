Rails.application.routes.draw do

  root to: 'welcome#hi'

  # custom controls for remixing existing track
  get 'mixes/:mix_id/mixes/new' => 'mixes#new_mix'
  post 'mixes/:mix_id/mixes' => 'mixes#create_mix'
  
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