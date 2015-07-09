Myflix::Application.routes.draw do
  get '/', to: 'static_pages#front'
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: 'videos#index'

  resources :videos, only: :show do
    collection do 
      get 'search', to: 'videos#search'
    end

  end
  resources :categories, only: :show

  get '/register', to: 'users#new'

  get '/login', to: 'sessions#new'
end
