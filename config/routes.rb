Rails.application.routes.draw do
  namespace :v1 do
    resource :user
    get 'users/search', to: 'users#search'

    resources :storages do
      resources :categories, only: %i[index create update destroy]
    end
  end
end
