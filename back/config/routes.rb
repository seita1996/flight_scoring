Rails.application.routes.draw do
  resources :areas
  resources :pzs
  resources :users
  resources :events
  resources :task_types
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
