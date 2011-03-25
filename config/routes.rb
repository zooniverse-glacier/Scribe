Scribe::Application.routes.draw do
  resources :templates
  
  match 'template_for_asset/:id' => "templates#template_for_asset"
  
  resources :annotations
  
  
  resources :transcriptions do
    collection do
      post :add_entity
    end
  end
  
  match 'transcribe' => "transcriptions#transcribe"
end
