Rails.application.routes.draw do
  get 'welcome/index'

  root 'welcome#index'
  get '/ruby-version' => 'application#ruby_version'
  resources :media do
   collection do
     get 'search', to: 'media#search'
   end 
  end
  
  get "media/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'
end
