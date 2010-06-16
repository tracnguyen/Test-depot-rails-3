Hiringapp::Application.routes.draw do |map|
  constraints(:subdomain => /.+/) do 
    devise_for :users
    resources :jobs
    
    namespace :pub do
      resources :jobs do
        resources :applicants
      end
    end
    
    root :to => "current_account#index"
  end
  
  devise_for :admins
  resources :accounts
  root :to => "welcome#index"
end
