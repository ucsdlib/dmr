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
  resources :courses do
   collection do
     post 'add_to_course', to: 'courses#add_to_course'
     get 'set_current_course', to: 'courses#set_current_course'
     get 'search', to: 'courses#search'
   end 
  end
  get "media/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'
end
