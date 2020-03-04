Rails.application.routes.draw do
  
  resources :lists do
    resources :tasks
  end
  resources :users do
    resources :tasks
  end
  resources :tasks
  post '/tasks/search', to: 'tasks#search'
  post '/tasks/next_ten_due', to: 'tasks#next_ten_due'
  post '/tasks/incomplete_tasks', to: 'tasks#incomplete_tasks'
  post '/tasks/:id' => 'tasks#complete'
  get '/signin' => "sessions#new"
  post '/signin' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  root "users#new"
  #get '/auth/facebook/callback' => 'sessions#create'
  match '/auth/:provider/callback', to: 'sessions#omnicreate', via: [:get, :post]
  

end
