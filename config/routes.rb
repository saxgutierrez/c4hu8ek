Rails.application.routes.draw do
  root 'pins#index'

  devise_for :users  #hubo que arreglar el error con la geme brypt
  resource :token, only: [:show]
  resources :pins, only: [:index, :new, :create]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :pins, only: [:index, :create, :authenticate_user, :authenticate_token, :authenticate!] #agregando dos métodos de autenticación en la API
    end
  end
end
