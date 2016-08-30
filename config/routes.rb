# encoding: utf-8
class CourseConstraint
  def matches?(request)
    params = request.path_parameters
    tmp_course = Course.find(params[:id])
    return false if params[:course] != tmp_course.course.parameterize('_')
    true
  end  
end
  
Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'
  get '/ruby-version' => 'application#ruby_version'
  resources :media do
   collection do
     get 'search', to: 'media#search'
   end 
  end
  resources :courses do
   collection do
     post 'add_to_course', to: 'courses#add_to_course'
     get 'search', to: 'courses#search'
     get 'clone_course', to: 'courses#clone_course'
     get 'send_email', to: 'courses#send_email'
     get 'archive', to: 'courses#archive'
     get 'archive_search', to: 'courses#archive_search'
     get 'lookup', to: 'courses#lookup'
   end
  end
  resources :analytics
    
  get 'media/:id/:ds', :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'  
  get 'courses/:id/:quarter/:year/:course', :to => 'courses#show', constraints: CourseConstraint.new, :as => :course_report
 
  get '/auth/shibboleth', as: :shibboleth
  get '/auth/developer', to: 'users/sessions#developer', as: :developer
  match '/auth/shibboleth/callback' => 'users/sessions#shibboleth', as: :callback, via: [:get, :post]
  get '/users/sign_in', :to => 'users/sessions#new', :as => :new_user_session
  get '/users/sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  match '*a', :to => 'errors#routing', via: [:get]
end


