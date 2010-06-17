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
    
    root :to => "current_account#index"
  end
  
  devise_for :admins, :controllers => {
    :sessions => "main/sessions",
    :passwords => "main/passwords",
    :unlocks => "main/unlocks"
  }
  resources :accounts
  root :to => "welcome#index"
end
