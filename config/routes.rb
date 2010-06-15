Hiringapp::Application.routes.draw do |map|
  constraints(:subdomain => /.+/) do 
    devise_for :users
    resources :jobs
    
    root :to => "current_account#index"
  end
  
  devise_for :admins
  resources :accounts
  root :to => "welcome#index"
end
