Scribe::Application.routes.draw do
  resources :templates
  
  resources :assets do
    resource :template
  end
    
  resources :annotations
  
  resources :books
  
  resources :transcriptions do
    collection do
      post :add_entity
    end
  end
  
  match 'transcribe' => "transcriptions#new"
  match 'about' => 'home#about'
  
  root :to => 'home#index'
  
end
