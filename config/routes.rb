Rails.application.routes.draw do
  get 'post/index'

  get 'post/show'

  get 'post/edit'

  get 'post/destroy'

  get 'post/update'

  get 'welcome/index'

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users, only: [:show, :index]
 # match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/:id/finish_signup' => 'post#index', via: [:get, :patch], :as => :finish_signup
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

end
