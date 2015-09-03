Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'
  get '/ruby-version' => 'application#ruby_version'
  #get 'welcome/home'
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
     get 'clone_course', to: 'courses#clone_course'
   end
  end
  
  get "media/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'  
  match "courses/:id/:quarter/:year/:course", :to => 'courses#show', :as => :course_report, via: [:get]
  
  get "/auth/shibboleth", as: :shibboleth
  get "/auth/developer", to: 'users/sessions#developer', as: :developer
  match "/auth/shibboleth/callback" => "users/sessions#shibboleth", as: :callback, via: [:get, :post]
  get '/users/sign_in', :to => "users/sessions#new", :as => :new_user_session
  get '/users/sign_out', :to => "users/sessions#destroy", :as => :destroy_user_session
end


