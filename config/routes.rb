Hiringapp::Application.routes.draw do |map|
  constraints(:subdomain => /.+/) do 
    devise_for :users
    
    resources :users, :only => [:new, :create, :update]
    
    resources :jobs
    
    resources :applicants
    match "applicants/:id/mark_as_unread" => "applicants#mark_as_unread", \
      :as => :mark_applicant_as_unread

    namespace :pub do
      resources :jobs do
        resources :applicants
      end
    end
    
    namespace :config do
      resource :admin
      resources :users, :only => [:index, :create]
    
      resources :job_stages do 
        post :order, :on => :collection
      end
    end
    
    match "dashboard" => "dashboard#index", :as => :dashboard
    match "dashboard" => "dashboard#index", :as => :user_root_path # for devise
    
    root :to => redirect('/pub/jobs')
  end
  
  devise_for :admins, :controllers => {
    :sessions => "main/sessions",
    :passwords => "main/passwords",
    :unlocks => "main/unlocks"
  }
  
  namespace :main do
    resources "accounts"
    root :to => "welcome#index"
  end
  
  root :to => "main/welcome#index"
end
