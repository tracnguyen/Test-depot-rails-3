Hiringapp::Application.routes.draw do |map|
  constraints(:subdomain => /.+/) do 
    devise_for :users
    
    resources :jobs
    resources :applicants
    
    namespace :pub do
      resources :jobs do
        resources :applicants
      end
    end
    
    root :to => "dashboard#index", :as => :dashboard
  end
  
  resources :accounts
  
  devise_for :admins, :controllers => {
    :sessions => "main/sessions",
    :passwords => "main/passwords",
    :unlocks => "main/unlocks"
  }
  root :to => "main/welcome#index"
end
