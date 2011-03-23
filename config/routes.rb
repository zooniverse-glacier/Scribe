Scribe::Application.routes.draw do
  resources :templates
  resources :annotations
  resources :transcriptions do
    collection do
      post :add_entity
    end
  end
end
