Rails.application.routes.draw do
  namespace :v1 do
    resource :user
  end
end
