Rails.application.routes.draw do
  namespace :v1 do
    resource :user
    get 'users/search', to: 'users#search'

    resources :storages do
      resources :categories, only: %i[index create update destroy]

      resources :stocks
      patch 'stocks/:id/favorite', to: 'stocks#favorite'
      patch 'stocks/:id/unfavorite', to: 'stocks#unfavorite'
      patch 'stocks/:id/increment', to: 'stocks#increment'
      patch 'stocks/:id/decrement', to: 'stocks#decrement'
    end
  end
end
