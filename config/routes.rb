Rails.application.routes.draw do
  devise_for :users
  resources :users do
    collection do
      get  :top_gamers, action: 'top_gamers'
      get :least_familiar, action: 'least_familiar'
    end
  end
  resources :guesses
  resources :photos

  root to: 'users#index'
end