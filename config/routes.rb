Rails.application.routes.draw do
  get 'welcome/index'

  root 'welcome#index'
  get '/ruby-version' => 'application#ruby_version'
  resources :media
  get "media/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'
end
