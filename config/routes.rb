Scribe::Application.routes.draw do
  resources :templates
  
  resources :assets do
    resource :template
    member do
      get :show_next
    end
    member do
      get :show_prev
    end
  end
    
  resources :annotations
  
  resources :asset_collections do |ac|
    collection do
      get :show_grid
      post :test
    end
  end
  
  resources :transcriptions do
    collection do
      post :add_entity
    end
  end
  
  match 'transcribe' => "transcriptions#new"
  match 'about' => 'home#about'
  
  root :to => 'home#index'
end
