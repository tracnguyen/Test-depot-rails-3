Hiringapp::Application.routes.draw do |map|
  constraints(:subdomain => /.+/) do 
    devise_for :users, :controllers => {
      :sessions => "subdomain/sessions",
      :passwords => "subdomain/passwords",
      :unlocks => "subdomain/unlocks"
    }
    
    resources :users, :only => [:new, :create, :update]
    
    resources :jobs
    resources :conversations
    resources :messages, :only => [:index, :show, :create] do
      get :content, :on => :member
      post :batch_process, :on => :collection 
    end
    
    resources :applicants do
      resources :activities, :only => [:index, :create]
      resources :attachments
      post :batch_process, :on => :collection 
      member do
        get :cover_letter
        get :resume
      end
    end
    
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
      resources :job_stages
      resources :email_settings
      resources :message_templates, :except => :new
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
