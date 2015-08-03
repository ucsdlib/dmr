Rails.application.routes.draw do
  get 'welcome/index'

  root 'welcome#home'
  get '/ruby-version' => 'application#ruby_version'
  get 'welcome/home'
  resources :media do
   collection do
     get 'search', to: 'media#search'
   end 
  end
  resources :courses
  get "media/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'
end
