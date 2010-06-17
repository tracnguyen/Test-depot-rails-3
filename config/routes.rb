Hiringapp::Application.routes.draw do |map|
  constraints(:subdomain => /.+/) do 
    devise_for :users
    
    resources :users, :only => :index
    match "users/:id/confirm" => "users#confirm", :as => :confirm_user
    
    resources :jobs
    resources :applicants do
      get :filter, :on => :collection
    end
    
    namespace :pub do
      resources :jobs do
        resources :applicants
      end
    end
    
    match "dashboard" => "dashboard#index", :as => :dashboard
    match "dashboard" => "dashboard#index", :as => :user_root_path # for devise
    
    root :to => "pub/jobs#index"
  end
  
  resources :accounts
  
  devise_for :admins, :controllers => {
    :sessions => "main/sessions",
    :passwords => "main/passwords",
    :unlocks => "main/unlocks"
  }
  
  root :to => "main/welcome#index"
end
