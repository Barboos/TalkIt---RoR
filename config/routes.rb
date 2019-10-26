Rails.application.routes.draw do

  root 'static_pages#home'

  get    '/help',       to: 'static_pages#help'

  get    '/about',      to: 'static_pages#about'

  get    '/contact',    to: 'static_pages#contact'

  get    '/signup',     to: 'users#new'

  post   '/signup',     to: 'users#create'

  get    '/login',      to: 'sessions#new'

  post   '/login',      to: 'sessions#create'

  delete '/logout',     to: 'sessions#destroy'

  resources :users, param: :id do
    member do
      get   :following, :followers
      post  "follow/:other_id", :action => "follow"
      delete "unfollow/:other_id", :action => "unfollow"
    end
    resources :microposts,     only:[:index]
  end
  resources :microposts,      only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]

end
