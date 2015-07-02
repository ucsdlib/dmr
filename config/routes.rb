Rails.application.routes.draw do
  get 'welcome/index'

  root 'welcome#index'
  get '/ruby-version' => 'application#ruby_version'
  resources :media

end
