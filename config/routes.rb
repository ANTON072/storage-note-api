Rails.application.routes.draw do
  namespace :v1 do
    resource :user
    get 'users/search', to: 'users#search'

    resources :storages do
      resources :categories, only: %i[index create update destroy]

      resources :stocks
      patch 'stocks/:id/favorite',   to: 'stocks#favorite'
      patch 'stocks/:id/item_count', to: 'stocks#item_count'
    end
  end
end
