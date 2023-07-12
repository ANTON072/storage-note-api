Rails.application.routes.draw do
  namespace :v1 do
    resource :user
    get 'users/search', to: 'users#search'
  end
end
